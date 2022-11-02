// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_speech/google_speech.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:lspapp/pages/home/variables.dart' as variables;
import '../../constants/api_path.dart';

const int tSampleRate = 16000;
typedef _Fn = void Function();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  late StreamSubscription? _mRecordingDataSubscription;
  bool _mRecorderIsInited = false;
  late BehaviorSubject<List<int>> audioStream;
  final _textController = TextEditingController();
  bool _validateText = false;
  late bool _firstLoad;
  late bool _isConsumingAPI;
  late int _animIndex;
  late int _animLenght;
  late List<String> _signToAnim;
  late String _signToAdd;
  late List<String> _victorQueue;
  late AnimationController controller;
  late AnimationController listenController;
  late List<String> singleLetter;
  late List<String> singleWords;
  final _signDictionary = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'K',
    'L',
    'LL',
    'M',
    'N',
    'Ñ',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    'ENFERMO',
    'HOSPITAL',
    'PERU',
    'MI',
    'COMER',
    'ESCUCHAR',
    'TOMAR',
    'MI',
    'YO',
    'SI',
    'CUANTO',
    'DONDE',
    'TU',
    'CUANDO',
    'QUE',
    'PORQUE',
    'COMO',
    'QUIEN',
    'AYUDA',
    'BAÑO',
    'CUAL',
    'AÑO',
    'DIA',
    'ESTUDIAR',
    'MAMA',
    'PAPA',
    'NOCHE',
    'NOMBRE',
    'TRABAJAR'
  ];

  Future<List> _getNLP(String sentence) async {
    print('STARTING NLP');
    Uri uri = Uri.parse(webServiceUrl);

    //final uri = Uri.http(webServiceUrl, '/LSP', query);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    print('PRE API CALL');
    final response = await http.post(uri,
        body: json.encode({
          "Oracion": sentence,
        }),
        headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      print('RESPONSE OK: ${response.body}');
      final jsonResponse = json.decode(response.body);
      List nlpWords =
          jsonResponse['mensaje'].toString().replaceAll('[', '').split(']');
      print('PALRABAS NLP: $nlpWords');
      return nlpWords;
    } else {
      throw Exception('Falló el consumo de la API');
    }
  }

  @override
  void initState() {
    super.initState();
    _signToAnim = [];
    _signToAdd = '';
    _firstLoad = true;
    _isConsumingAPI = false;
    _animIndex = 0;
    _animLenght = 1;
    singleWords = [];
    _victorQueue = [];
    setState(() {
      _textController.text = variables.textMem;
    });

    controller = AnimationController(
        duration: Duration(milliseconds: 1300), vsync: this);

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        print('Animation completed');
        if (_animIndex < _animLenght - 1) {
          setState(() {
            _animIndex++;
          });
          print(
              'Animation index: $_animIndex, animation lenght: $_animLenght, sign to reproduce: ${_signToAnim[_animIndex]}');
          if (_signToAnim[_animIndex] == _signToAnim[_animIndex - 1]) {
            print('Same sign');
            controller.reset();
            await controller.forward();
          }
        }
        controller.reset();
      }
    });

    listenController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    listenController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        listenController.reset();
      }
    });

    _openRecorder();
  }

  @override
  void dispose() {
    controller.dispose();
    _textController.dispose();
    stopRecorder();
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  void changeAnimSpeed() {
    switch (variables.selectedRadioValue) {
      case 0:
        controller.duration = Duration(milliseconds: 2000);
        break;
      case 1:
        controller.duration = Duration(milliseconds: 1500);
        break;
      case 2:
        controller.duration = Duration(milliseconds: 1000);
        break;
    }
  }

  Future<void> stopRecorder() async {
    await _mRecorder!.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
    await audioStream.close();
  }

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder!.openRecorder();
    setState(() {
      _mRecorderIsInited = true;
    });
  }

  Future<void> setAudioConfig() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void> record() async {
    assert(_mRecorderIsInited);
    var recordingDataController = StreamController<Food>();

    audioStream = BehaviorSubject<List<int>>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        audioStream.add(buffer.data!);
      }
    });

    await setAudioConfig().then((value) async {
      await _mRecorder!.startRecorder(
        toStream: recordingDataController.sink,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: tSampleRate,
      );
    });

    final serviceAccount = ServiceAccount.fromString((await rootBundle
        .loadString('assets/sign/cedar-abacus-275721-efb57f834e66.json')));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        audioStream);
    String text = '';
    responseStream.listen((data) async {
      try {
        if (data.results.first.isFinal == true) {
          await stopRecorder();
          _isConsumingAPI = true;
          text = await _fetchGoogleResults(data);
          print("Google translate results: $text");
          setState(() {});
          await _loadQueue(text);
          _victorPlayer();
        }
      } catch (e) {
        print('isFinal Error: $e');
      }
    }, onDone: () async {});

    setState(() {});
  }

  Future<String> _fetchGoogleResults(var data) async {
    String res =
        data.results.map((e) => e.alternatives.first.transcript).join('\n');
    return res;
  }

  Future<String> _sendToNlp(String text) async {
    print("enviando al backend");
    List nlpResult = await _getNLP(text);
    print("recibe del backend");
    text = nlpResult.join(' ');
    return text;
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: false,
        sampleRateHertz: 16000,
        languageCode: 'es-PE',
      );

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited) {
      return null;
    }
    return _mRecorder!.isStopped
        ? record
        : () {
            stopRecorder().then((value) => setState(() {}));
          };
  }

  String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüŠšŸÿýŽž,.-';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuSsYyyZz   ';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  Future<void> _victorPlayer() async {
    //TODO: ELIMINAR SEÑAS YA REPRODUCIDAS DE LA COLA
    //CUANDO SE EMPIECE A GRABAR UN NUEVO AUDIO, SE PAUSA LA REPRODUCCIÓN ACTUAL Y LUEGO SE REANUDA LA REPRODUCCIÓN CON FALTANTES Y NUEVAS
    changeAnimSpeed();
    _animIndex = 0;
    if (_victorQueue.isNotEmpty) {
      List<String> victorQueueTemp = _victorQueue;
      //Si se pausa, podemos saber donde nos quedamos usando el index.
      //_victorQueue[index]
      setState(() {
        _firstLoad = false;
        victorQueueTemp.add('assets/sign/IDLE.json');
        _animLenght = victorQueueTemp.length;
        _isConsumingAPI = false;
        _signToAnim = victorQueueTemp;
      });
      print("Reproduciendo: $_signToAnim");
    }
  }

  Future<void> _loadQueue(String result) async {
    String resultNLP = await _sendToNlp(result);
    setState(() {
      resultNLP = removeDiacritics(resultNLP);
      resultNLP = resultNLP.toUpperCase();
      _textController.text = resultNLP;
      variables.textMem = _textController.text;
    });
    _addSignsToQueue(resultNLP);
  }

  void _onPressedLoadQueue() async {
    setState(() {
      _textController.text = removeDiacritics(_textController.text);
      _textController.text = _textController.text.toUpperCase();
      variables.textMem = _textController.text;
    });
    _addSignsToQueue(_textController.text);
    _victorPlayer();
  }

  void _addSignsToQueue(String text) {
    _victorQueue.clear();
    singleWords = text.trim().split(' ');
    for (String word in singleWords) {
      if (_signDictionary.contains(word)) {
        setState(() {
          _signToAdd = 'assets/sign/$word.json';
          _victorQueue.add(_signToAdd);
        });
      } else {
        setState(() {
          singleLetter = word.trim().split("");
        });
        for (String letter in singleLetter) {
          setState(() {
            _signToAdd = 'assets/sign/$letter.json';
            _victorQueue.add(_signToAdd);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color.fromARGB(43, 139, 198, 207),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: const Color(0XFF007AFF),
                              width: 2.0,
                            )),
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: _textController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Esperando traducción",
                              fillColor: Colors.transparent,
                              filled: true,
                              border: InputBorder.none,
                              labelText: "",
                              errorText:
                                  _validateText ? 'Ingresar Texto' : null,
                              contentPadding: EdgeInsets.only(
                                left: 15,
                                bottom: 11,
                                top: 11,
                                right: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_textController.text.isEmpty ||  _textController.text==" " || _textController.text=="  " || _textController.text=="\n"
                        || _textController.text=="\n\n"|| _textController.text=="\n\n\n"|| _textController.text=="\n\n\n\n"
                        || _textController.text=="\n\n\n\n\n") {
                          _validateText = true;
                        } else {
                          _validateText = false;
                          FocusScope.of(context).unfocus();
                          _onPressedLoadQueue();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.40),
                        child: Container(
                            alignment: Alignment.center,
                            height: 70.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(
                              Icons.front_hand_outlined,
                              size: 60.0,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Expanded(
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: _firstLoad
                                ? Lottie.asset('assets/sign/IDLE.json',
                                    animate: false)
                                : _mRecorder!.isRecording
                                    ? Lottie.asset('assets/sign/ESCUCHAR.json',
                                        controller: listenController,
                                        onLoaded: (composition) {
                                        listenController.forward();
                                      })
                                    : _isConsumingAPI
                                        ? Lottie.asset('assets/sign/IDLE.json',
                                            animate: false)
                                        : Lottie.asset(_signToAnim[_animIndex],
                                            controller: controller,
                                            onLoaded: (composition) {
                                            controller.forward();
                                          }))),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: getRecorderFn(),
                tooltip: 'Listen',
                child: Icon(
                  _mRecorder!.isRecording ? Icons.mic : Icons.mic_off,
                ),
              )),
        ));
  }
}
