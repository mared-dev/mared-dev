import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPostItem extends StatefulWidget {
  final String videoUrl;
  VideoPostItem({required this.videoUrl});

  @override
  _VideoPostItemState createState() => _VideoPostItemState();
}

class _VideoPostItemState extends State<VideoPostItem> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      showOptions: false,
      // aspectRatio:5/8,
      autoInitialize: true,
      showControls: true,
      autoPlay: false,
      looping: false,
      customControls: MaterialControls(
        showPlayButton: true,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
