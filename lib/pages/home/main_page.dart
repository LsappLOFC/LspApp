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
  //final SpeechToText _speechToText = SpeechToText();
  //bool _speechEnabled = false;
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  late StreamSubscription? _mRecordingDataSubscription;
  bool _mplaybackReady = false;
  bool _mRecorderIsInited = false;
  String _lastWords = 'IDLE';
  late bool _firstLoad;
  late String _signToAnim;
  late AnimationController controller;
  late List<String> singleLetter;
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
    _firstLoad = true;
    controller = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
        controller.reset();
      }
    });
    //_initSpeech();
    _openRecorder();
  }

  @override
  void dispose() {
    controller.dispose();
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

  // ----------------------  Here is the code to record to a Stream ------------

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
        text =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
        print("Google translate results: $text");
        _onTextResultToSign(text);
        setState(() {
          _firstLoad = false;
        });
      }
    }, onDone: () async {});

    setState(() {});
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

/*
  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _firstLoad = false;
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

*/
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

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onTextResultToSign(String result) async {
    setState(() {
      result = removeDiacritics(result);
      result = result.toUpperCase();
      _lastWords = result;
    });
    List<String> singleWords = result.trim().split(' ');
    for (String word in singleWords) {
      if (_signDictionary.contains(word)) {
        setState(() {
          _signToAnim = 'assets/sign/IDLE.json';
        });
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _signToAnim = 'assets/sign/$word.json';
        });

        await Future.delayed(const Duration(milliseconds: 1500));
      } else {
        setState(() {
          singleLetter = word.trim().split("");
        });

        for (String letter in singleLetter) {
          if (letter == ' ') {
            setState(() {
              letter = 'ESPACIO';
            });
          }
          setState(() {
            _signToAnim = 'assets/sign/IDLE.json';
          });
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            _signToAnim = 'assets/sign/$letter.json';
          });

          await Future.delayed(const Duration(milliseconds: 1500));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: const Color(0XFF007AFF),
                            width: 2.0,
                          )),
                      child: SingleChildScrollView(
                        child: _lastWords == 'IDLE'
                            ? Text(
                                textAlign: TextAlign.center,
                                'Esperando traducción...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              )
                            : Text(
                                textAlign: TextAlign.center,
                                _lastWords,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: _firstLoad
                              ? Lottie.asset('assets/sign/IDLE.json',
                                  animate: false)
                              : _mRecorder!.isRecording
                                  ? Lottie.asset('assets/sign/IDLE.json',
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
