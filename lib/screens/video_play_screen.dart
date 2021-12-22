// ignore: import_of_legacy_library_into_null_safe
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final YoutubePlayerController controller;
  const VideoPlayerScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(controller);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final YoutubePlayerController controller;
  _VideoPlayerScreenState(this.controller);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
            ),
          ),
          Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(EvaIcons.closeCircle),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ))
        ],
      ),
    );
  }
}
