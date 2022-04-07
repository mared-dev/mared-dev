import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/services/firebase/firebase_file_upload_service.dart';
import 'package:video_player/video_player.dart';

class PreviewPickedVideo extends StatefulWidget {
  final XFile video;
  final VideoPlayerController videoPlayerController;
  final onCompleteCallback;

  const PreviewPickedVideo(
      {Key? key,
      required this.video,
      required this.videoPlayerController,
      required this.onCompleteCallback})
      : super(key: key);
  @override
  _PreviewPickedVideoState createState() => _PreviewPickedVideoState();
}

class _PreviewPickedVideoState extends State<PreviewPickedVideo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.commentButtonColor,
        ),
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                widget.videoPlayerController.play();
              },
              onDoubleTap: () {
                widget.videoPlayerController.pause();
              },
              child: Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    height: widget.videoPlayerController.value.size.height,
                    width: widget.videoPlayerController.value.size.width,
                    child: VideoPlayer(widget.videoPlayerController),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      heroTag: "Reselect Image",
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.backspace,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FloatingActionButton(
                      heroTag: "Confirm Image",
                      backgroundColor: constantColors.blueColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () async {
                        widget.videoPlayerController.pause().then((_) {
                          // CoolAlert.show(
                          //     context: context,
                          //     type: CoolAlertType.loading,
                          //     text:
                          //         "Please wait, your story is being uploaded!");
                          LoadingHelper.startLoading();
                        });

                        String videoUrl =
                            await FirebaseFileUploadService.uploadPostVideo(
                                context: context, video: widget.video);
                        LoadingHelper.endLoading();

                        widget.onCompleteCallback(videoUrl: videoUrl);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.dispose();
  }
}
