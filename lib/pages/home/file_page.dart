import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';

class FilePage extends StatefulWidget {
  const FilePage({Key? key}) : super(key: key);

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  bool senasIsSelected = true;
  bool textIsSelected = false;
  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  String path = '';
  //final FlutterFFmpeg FFmpeg = FlutterFFmpeg();

  void recognize() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString((await rootBundle
        .loadString('assets/sign/cedar-abacus-275721-efb57f834e66.json')));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();
    final audio = await _getAudioContent();

    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        text = value.results
            .map((e) => e.alternatives.first.transcript)
            .join('\n');
        print('TEXTO RECONOCIDO: $text');
      });
    }).whenComplete(() => setState(() {
          recognizeFinished = true;
          recognizing = false;
        }));
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.ENCODING_UNSPECIFIED,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 8000,
      languageCode: 'es-PE');

  Future<List<int>> _getAudioContent() async {
    return File(path).readAsBytesSync().toList();
  }

  bool showContent() {
    if (senasIsSelected) {
      return true;
    } else {
      return false;
    }
  }

  void _pickFile() async {
    final res = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (res == null) {
      return;
    }
    setState(() {
      text = '';
      path = res.files.single.path!;
    });
    print('NOMBRE DEL ARCHIVO: ${res.files.single.name}');
    print('PATH DEL ARCHIVO ${res.files.single.path}');
    FFprobeKit.getMediaInformation(path).then((session) async {
      final information = await session.getMediaInformation();

      if (information == null) {
        // CHECK THE FOLLOWING ATTRIBUTES ON ERROR
        final state =
            FFmpegKitConfig.sessionStateToString(await session.getState());
        final returnCode = await session.getReturnCode();
        final failStackTrace = await session.getFailStackTrace();
        final duration = await session.getDuration();
        final output = await session.getOutput();
        print('output NULL: $output');
      }
      final output = await session.getOutput();
      print('STATE CONTENT: $output');
    });
    /*FFmpegKit.execute(
            '-i $path -q:a 0 -map a /storage/emulated/0/download/ffmpeg_test.mp3')
        .then((session) async {
      // Unique session id created for this execution
      final sessionId = session.getSessionId();
      print('sessionId: $sessionId');

      // Command arguments as a single string
      final command = session.getCommand();
      print('command: $command');

      // Command arguments
      final commandArguments = session.getArguments();
      print('commandArguments: $commandArguments');

      // State of the execution. Shows whether it is still running or completed
      final state = await session.getState();
      print('state: $state');

      // Return code for completed sessions. Will be undefined if session is still running or FFmpegKit fails to run it
      final returnCode = await session.getReturnCode();
      print('returnCode: $returnCode');

      final startTime = session.getStartTime();
      print('startTime: $startTime');
      final endTime = await session.getEndTime();
      print('endTime: $endTime');
      final duration = await session.getDuration();
      print('duration: $duration');

      // Console output generated for this execution
      final output = await session.getOutput();
      print('output: $output');
      // The stack trace if FFmpegKit fails to run a command
      final failStackTrace = await session.getFailStackTrace();
      print('failStackTrace: $failStackTrace');
      // The list of logs generated for this execution
      final logs = await session.getLogs();
      print('logs: $logs');

      // The list of statistics generated for this execution (only available on FFmpegSession)
      final statistics = await (session as FFmpegSession).getStatistics();
    });*/

    /*if (!recognizing)*/ recognize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40.0, left: 20.0),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Subir Archivos",
                style: GoogleFonts.poppins(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                width: 180.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0XFF007AFF),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    senasIsSelected
                        ? Container(
                            width: 66.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40.0)),
                            child: const Center(
                              child: Text(
                                "Señas",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                textIsSelected = !textIsSelected;
                                senasIsSelected = !senasIsSelected;
                              });
                            },
                            child: const Text(
                              "Señas",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                    textIsSelected
                        ? Container(
                            width: 66.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40.0)),
                            child: const Center(
                              child: Text(
                                "Text",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                textIsSelected = !textIsSelected;
                                senasIsSelected = !senasIsSelected;
                              });
                            },
                            child: const Text(
                              "Text",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            showContent()
                ? Image.asset(
                    "assets/images/img_2.png",
                    scale: MediaQuery.of(context).size.height * 0.0024,
                  )
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: const Color(0XFF007AFF),
                            width: 2.0,
                          )),
                      child: SingleChildScrollView(
                        child: text == ''
                            ? const Text(
                                'Esperando traducción...',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Text(
                                text,
                                style: const TextStyle(fontSize: 14),
                              ),
                      ),
                    ),
                  ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 30.0),
                  child: InkWell(
                    onTap: () {
                      _pickFile();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.upload_sharp,
                          size: 30.0,
                          color: Color(0XFF007AFF),
                        ),
                        Text(
                          "Elegir Archivos",
                          style: GoogleFonts.poppins(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF007AFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0, left: 40.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Tipos de archivos admitidos: \nwav, mp3, mp4, txt",
                    style: GoogleFonts.poppins(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
