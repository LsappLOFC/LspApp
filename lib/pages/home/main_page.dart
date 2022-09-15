// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_speech/google_speech.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

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
  late bool _firstLoad;
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
    'TU'
  ];

  @override
  void initState() {
    super.initState();
    _signToAnim = [];
    _signToAdd = '';
    _firstLoad = true;
    _animIndex = 0;
    _animLenght = 1;
    singleWords = [];
    _victorQueue = [];
    controller = AnimationController(
        duration: const Duration(milliseconds: 1300), vsync: this);

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

  Future<void> stopRecorder() async {
    await _mRecorder!.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
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
    String finalResult = text;
    await Future.delayed(Duration(seconds: 3));
    print("recibe del backend");
    return finalResult;
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
    //REPRODUCIR REPETIDAS
    _animIndex = 0;
    if (_victorQueue.isNotEmpty) {
      var victorQueueCopy = _victorQueue;
      //Si se pausa, podemos saber donde nos quedamos usando el index.
      //_victorQueue[index]
      setState(() {
        _firstLoad = false;
        victorQueueCopy.add(
            'assets/sign/IDLE.json'); // Esto debe cambiar, (buscar otra solución para el problema de la ultima seña que se repite)
        _animLenght = victorQueueCopy.length;
        _signToAnim = victorQueueCopy;
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
    });
    _addSignsToQueue(resultNLP);
  }

  void _onPressedLoadQueue() async {
    setState(() {
      _textController.text = removeDiacritics(_textController.text);
      _textController.text = _textController.text.toUpperCase();
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
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                      _onPressedLoadQueue();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.40),
                      alignment: Alignment.bottomCenter,
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
            )));
  }
}
