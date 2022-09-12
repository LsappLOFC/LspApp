// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
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

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  late StreamSubscription? _mRecordingDataSubscription;
  bool _mplaybackReady = false;
  bool _mRecorderIsInited = false;
  bool _pauseState = false;
  final _textController = TextEditingController();
  String _lastWords = 'IDLE';
  late bool _firstLoad;
  late String _signToAnim;
  late String _signToAdd;
  late List<String> _victorQueue;
  late AnimationController controller;
  late List<String> singleLetter;
  late List<String> singleWords;
  final _signDictionary = [
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
    'YO'
  ];

  @override
  void initState() {
    super.initState();
    _signToAnim = '';
    _signToAdd = '';
    _firstLoad = true;
    singleWords = [];
    _victorQueue = [];
    controller = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
        controller.reset();
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
    _mplaybackReady = true;
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

  late StreamSubscription<List<int>> audioStreamSubscription;
  late BehaviorSubject<List<int>> audioStream;

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
      if (data.results.first.isFinal == true) {
        await stopRecorder();
        text = await _fetchGoogleResults(data);
        print("Google translate results: $text");
        setState(() {});
        await _loadQueue(text);
        _victorPlayer();
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
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüŠšŸÿýŽž,.';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuSsYyyZz  ';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  Future<void> _victorPlayer() async {
    //TODO: ELIMINAR SEÑAS YA REPRODUCIDAS DE LA COLA
    //CUANDO SE EMPIECE A GRABAR UN NUEVO AUDIO, SE PAUSA LA REPRODUCCIÓN ACTUAL Y LUEGO SE REANUDA LA REPRODUCCIÓN CON FALTANTES Y NUEVAS
    if (_victorQueue.isNotEmpty) {
      var victorQueueCopy = _victorQueue;
      for (String sign in victorQueueCopy) {
        if (_mRecorder!.isRecording) {
          break;
        }
        //TODO: MEJORAR REPRODUCCIÓN DE LOTTIE
        setState(() {
          _signToAnim = sign;
        });
        print(_signToAnim);
        await Future.delayed(const Duration(milliseconds: 1500));
      }
      setState(() {
        _signToAnim = 'assets/sign/IDLE.json';
      });
    }
  }

  Future<void> _loadQueue(String result) async {
    String resultNLP = await _sendToNlp(result);
    _victorQueue.clear();
    setState(() {
      resultNLP = removeDiacritics(resultNLP);
      resultNLP = resultNLP.toUpperCase();
      _textController.text = resultNLP;
      _firstLoad = false;
    });
    singleWords = resultNLP.trim().split(' ');
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

  void _onPressedLoadQueue() async {
    _victorQueue.clear();
    setState(() {
      _textController.text = removeDiacritics(_textController.text);
      _textController.text = _textController.text.toUpperCase();
      _firstLoad = false;
    });
    singleWords = _textController.text.trim().split(' ');
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
    _victorPlayer();
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
                  ElevatedButton(
                      onPressed: () {
                        _onPressedLoadQueue();
                      },
                      child: Text('Traducir')),
                  Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: _firstLoad
                              ? Lottie.asset('assets/sign/IDLE.json',
                                  animate: false)
                              : _mRecorder!.isRecording
                                  ? Lottie.asset('assets/sign/ESCUCHAR.json',
                                      animate: false)
                                  : Lottie.asset(_signToAnim,
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
