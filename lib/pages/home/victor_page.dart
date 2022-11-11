// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:lspapp/utilities/constraints.dart';
import 'package:lspapp/utilities/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_speech/google_speech.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:lspapp/utilities/variables.dart' as variables;

const int tSampleRate = 16000;
typedef _Fn = void Function();

class VictorPage extends StatefulWidget {
  const VictorPage({Key? key}) : super(key: key);

  @override
  State<VictorPage> createState() => _VictorPageState();
}

class _VictorPageState extends State<VictorPage> with TickerProviderStateMixin {
  final _keyForm = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  late StreamSubscription? _mRecordingDataSubscription;
  bool _mRecorderIsInited = false;
  late BehaviorSubject<List<int>> audioStream;
  final _textController = TextEditingController();
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

    str = str.replaceAll("\n", "");

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
      if (signDictionary.contains(word)) {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mySecundaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _keyForm,
          child: Column(
            children: <Widget>[
              _inputBox(context),
              _sendbutton(context),
              _victor(),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.2,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: myMainColor,
              onPressed: getRecorderFn(),
              tooltip: 'Listen',
              child: Icon(
                _mRecorder!.isRecording ? Icons.mic : Icons.mic_off,
                size: 35,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _victor() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: _firstLoad
            ? Lottie.asset('assets/sign/IDLE.json', animate: false)
            : _mRecorder!.isRecording
                ? Lottie.asset('assets/sign/ESCUCHAR.json',
                    controller: listenController, onLoaded: (composition) {
                    listenController.forward();
                  })
                : _isConsumingAPI
                    ? Lottie.asset('assets/sign/IDLE.json', animate: false)
                    : Lottie.asset(_signToAnim[_animIndex],
                        controller: controller, onLoaded: (composition) {
                        controller.forward();
                      }),
      ),
    );
  }

  Container _inputBox(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1),
      child: Scrollbar(
        controller: _scrollController,
        child: TextFormField(
          minLines: 8,
          maxLines: 8,
          keyboardType: TextInputType.multiline,
          controller: _textController,
          validator: (value) {
            return _validateText(value!.trim());
          },
          decoration: myInputDecoration(
              'Hable por el micrófono o escriba aquí para traducir'),
          style: myTitleStyle(),
        ),
      ),
    );
  }

  InkWell _sendbutton(BuildContext context) {
    return InkWell(
        onTap: () {
          if (_keyForm.currentState!.validate()) {
            _onPressedLoadQueue();
          }
        },
        child: sendButton(context));
  }
}

String? _validateText(String value) {
  if (value.isEmpty) {
    return 'Diga algo para traducirlo';
  }
  return null;
}
