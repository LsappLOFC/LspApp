// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lspapp/utilities/constraints.dart';
import 'package:lspapp/utilities/widgets.dart';
import 'package:video_player/video_player.dart';

class IndicationsPage extends StatefulWidget {
  const IndicationsPage({Key? key}) : super(key: key);

  static String id = '/indications';

  @override
  State<IndicationsPage> createState() => _IndicationsPageState();
}

class _IndicationsPageState extends State<IndicationsPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(urlVideo)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((value) => controller.play());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mySecundaryAppBar(context, 'Indicaciones de uso'),
      body: Container(
        color: mySecundaryColor,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: VideoPlayerFullScreenWidget(controller: controller),
        ),
      ),
    );
  }
}

class VideoPlayerFullScreenWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const VideoPlayerFullScreenWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.isInitialized
          ? Container(
              alignment: Alignment.topCenter,
              child: buildVideo(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cargando video ...",
                    style: myTitleStyle(),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );

  Widget buildVideo() => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildVideoPlayer(),
          BasicOverlayWidget(controller: controller),
        ],
      );

  Widget buildVideoPlayer() => buildFullScreen(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );

  Widget buildFullScreen({required Widget child}) {
    final size = controller.value.size;
    final width = size.width;
    final heigth = size.height;

    return FittedBox(
      fit: BoxFit.fill,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        height: heigth,
        child: child,
      ),
    );
  }
}

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const BasicOverlayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            controller.value.isPlaying ? controller.pause() : controller.play(),
        child: Stack(
          children: <Widget>[
            buildPlay(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildIndicator(),
            ),
          ],
        ),
      );

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,
      );

  Widget buildPlay() => controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
        );
}
