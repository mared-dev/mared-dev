import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnailItem extends StatefulWidget {
  final XFile video;

  const VideoThumbnailItem({Key? key, required this.video}) : super(key: key);
  @override
  _VideoThumbnailItemState createState() => _VideoThumbnailItemState();
}

class _VideoThumbnailItemState extends State<VideoThumbnailItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.path)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95.0,
      height: 95.0,
      child: VideoPlayer(_controller),
    );
  }
}
