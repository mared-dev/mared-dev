import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/utils/firebase_general_helpers.dart';
import 'package:mared_social/widgets/dialogs/contact_user_dialog.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/post_helpers.dart';

class VideoPostItem extends StatefulWidget {
  //TODO:create a post model
  final String videoUrl;
  final String videoThumbnailLink;
  final String userId;
  VideoPostItem(
      {required this.videoUrl,
      required this.videoThumbnailLink,
      required this.userId});

  @override
  _VideoPostItemState createState() => _VideoPostItemState();
}

class _VideoPostItemState extends State<VideoPostItem> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  late bool videoInit;
  String phoneNumber = '.';
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
            onTap: () async {
              if (_videoPlayerController.value.isPlaying) {
                _videoPlayerController.pause();
                if (phoneNumber == '.') {
                  LoadingHelper.startLoading();
                  var user = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .get();
                  LoadingHelper.endLoading();
                  phoneNumber = GeneralFirebaseHelpers.getStringSafely(
                      key: 'usercontactnumber', doc: user);
                }

                if (phoneNumber.isNotEmpty) {
                  showContactDialog(phoneNumber: phoneNumber, context: context)
                      .then((value) {
                    _videoPlayerController.play();
                  });
                }
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
    // if(_chewieController.ini)
    // _chewieController.dispose();
    super.dispose();
  }
}
