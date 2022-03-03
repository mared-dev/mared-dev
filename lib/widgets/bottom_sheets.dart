import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firebase_file_upload_service.dart';
import 'package:mared_social/utils/pick_files_helper.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

final ConstantColors constantColors = ConstantColors();

previewStoryImage(
    {required BuildContext context,
    required XFile? video,
    required VideoPlayerController videoPlayerController,
    required onCompleteCallback}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return SafeArea(
        bottom: true,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
          ),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  videoPlayerController.play();
                },
                onDoubleTap: () {
                  videoPlayerController.pause();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: constantColors.whiteColor,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: videoPlayerController.value.isInitialized
                        ? VideoPlayer(
                            videoPlayerController,
                          )
                        : LoadingWidget(constantColors: constantColors),
                  ),
                  // child: Image.file(storyImage),
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
                          videoPlayerController.dispose().then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            addStory(
                                context: context,
                                videoPlayerController: videoPlayerController,
                                onCompleteCallback: onCompleteCallback);
                          });
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
                          videoPlayerController.pause().then((_) {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                text:
                                    "Please wait, your story is being uploaded!");
                          });

                          String videoUrl =
                              await FirebaseFileUploadService.uploadPostVideo(
                                  context: context, video: video);
                          onCompleteCallback(videoUrl: videoUrl);
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
    },
  );
}

addStory(
    {required BuildContext context,
    required VideoPlayerController videoPlayerController,
    required onCompleteCallback}) {
  late XFile? _video;
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        bottom: true,
        child: StatefulBuilder(builder: (context, innerState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "Gallery",
                          backgroundColor: constantColors.greenColor,
                          child: Icon(
                            Icons.photo_album,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () async {
                            XFile? video = await PickFilesHelper.pickVide(
                                source: ImageSource.gallery);

                            innerState(() {
                              _video = video;
                            });

                            print(_video!.path);

                            videoPlayerController =
                                VideoPlayerController.file(File(_video!.path));

                            videoPlayerController
                              ..initialize().then((value) {
                                videoPlayerController.play();
                                previewStoryImage(
                                    context: context,
                                    videoPlayerController:
                                        videoPlayerController,
                                    video: _video,
                                    onCompleteCallback: onCompleteCallback);
                              });
                          },
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "Camera",
                          backgroundColor: constantColors.blueColor,
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () async {
                            XFile? video = await PickFilesHelper.pickVide(
                                source: ImageSource.camera);

                            innerState(() {
                              _video = video;
                            });

                            print(_video!.path);

                            videoPlayerController =
                                VideoPlayerController.file(File(_video!.path));

                            videoPlayerController
                              ..initialize().then((value) {
                                videoPlayerController.play();
                                previewStoryImage(
                                    context: context,
                                    video: _video,
                                    videoPlayerController:
                                        videoPlayerController,
                                    onCompleteCallback: onCompleteCallback);
                              });
                          },
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      );
    },
  );
}
