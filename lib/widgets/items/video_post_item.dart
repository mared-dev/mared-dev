import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPostItem extends StatefulWidget {
  final String videoUrl;
  final String videoThumbnailLink;
  VideoPostItem({required this.videoUrl, required this.videoThumbnailLink});

  @override
  _VideoPostItemState createState() => _VideoPostItemState();
}

class _VideoPostItemState extends State<VideoPostItem> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  late bool videoInit;
  @override
  void initState() {
    super.initState();
    videoInit = false;
    _initVideo();
  }

  @override
  Widget build(BuildContext context) {
    return videoInit
        ? GestureDetector(
            onTap: () {
              if (_videoPlayerController.value.isPlaying) {
                _videoPlayerController.pause();
              } else {
                _videoPlayerController.play();
              }
            },
            child: VisibilityDetector(
              key: Key(widget.videoUrl),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                if (visiblePercentage >= 60) {
                  _videoPlayerController.play();
                } else {
                  _videoPlayerController.pause();
                }
              },
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          )
        : CachedNetworkImage(imageUrl: widget.videoThumbnailLink);
  }

  _initVideo() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      showOptions: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      showControls: false,
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
    setState(() {
      videoInit = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
