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

    _videoPlayerController=VideoPlayerController.network(
        widget.videoUrl
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio:5/8,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
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
    // TODO: implement dispose
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
