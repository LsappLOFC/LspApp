import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = 'IDLE';
  late int _pos;
  late bool _listening;
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
    'HOSPITAL'
  ];

  @override
  void initState() {
    super.initState();
    _signToAnim = '';
    _pos = 0;
    _firstLoad = true;
    _listening = false;
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
        controller.reset();
      }
    });
    _initSpeech();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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

  String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      setState(() {
        _lastWords = result.recognizedWords;
        _lastWords = removeDiacritics(_lastWords);
        _lastWords = _lastWords.toUpperCase();
      });
      if (_signDictionary.contains(_lastWords)) {
        setState(() {
          _signToAnim = 'assets/sign/$_lastWords.json';
        });
        print(_signToAnim);
      } else {
        print('Inicio ELSE $_lastWords');
        setState(() {
          singleLetter = _lastWords.trim().split("");
        });
        print('Inicio ELSE $singleLetter');
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
          print(_signToAnim);
          await Future.delayed(const Duration(milliseconds: 1850));
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
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? _lastWords
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
            Container(
                child: _firstLoad
                    ? Lottie.asset('assets/sign/IDLE.json', animate: false)
                    : _speechToText.isNotListening
                        ? Lottie.asset(_signToAnim, controller: controller,
                            onLoaded: (composition) {
                            controller.forward();
                          })
                        : Lottie.asset('assets/sign/IDLE.json', animate: false))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    ));
  }
}
