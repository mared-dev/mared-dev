import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/Stories/stories_helper.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StoryWidgets {
  final ConstantColors constantColors = ConstantColors();
  TextEditingController storyHighlightTitleController = TextEditingController();

  XFile? _video;
  VideoPlayerController? _videoPlayerController;
  late UploadTask videoUploadTask;
  late String videoUrl;

  Future uploadStoryVideo({required BuildContext context}) async {
    Reference videoRef = FirebaseStorage.instance
        .ref()
        .child('stories/${_video!.path}/${Timestamp.now()}');

    videoUploadTask = videoRef.putFile(
        File(_video!.path), SettableMetadata(contentType: 'video/mp4'));

    await videoUploadTask.whenComplete(() {
      print("video uploaded");
    });
    await videoRef.getDownloadURL().then((url) {
      videoUrl = url;
    });
  }

  addStory({required BuildContext context}) {
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
                              XFile? video = await ImagePicker()
                                  .pickVideo(source: ImageSource.gallery);

                              innerState(() {
                                _video = video;
                              });

                              print(_video!.path);

                              _videoPlayerController =
                                  VideoPlayerController.file(
                                      File(_video!.path));

                              _videoPlayerController!
                                ..initialize().then((value) {
                                  _videoPlayerController!.play();
                                  previewStoryImage(
                                      context: context,
                                      storyImage: File(_video!.path));
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
                              XFile? video = await ImagePicker()
                                  .pickVideo(source: ImageSource.camera);

                              innerState(() {
                                _video = video;
                              });

                              print(_video!.path);

                              _videoPlayerController =
                                  VideoPlayerController.file(
                                      File(_video!.path));

                              _videoPlayerController!
                                ..initialize().then((value) {
                                  _videoPlayerController!.play();
                                  previewStoryImage(
                                      context: context,
                                      storyImage: File(_video!.path));
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

  previewStoryImage({required BuildContext context, required File storyImage}) {
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
                    _videoPlayerController!.play();
                  },
                  onDoubleTap: () {
                    _videoPlayerController!.pause();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: constantColors.whiteColor,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _videoPlayerController!.value.isInitialized
                          ? VideoPlayer(
                              _videoPlayerController!,
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
                            _videoPlayerController!.dispose().then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              addStory(context: context);
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
                            _videoPlayerController!.pause().then((_) {
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.loading,
                                  text:
                                      "Please wait, your story is being uploaded!");
                            });

                            await uploadStoryVideo(context: context)
                                .whenComplete(() async {
                              try {
                                String storyId = nanoid(14).toString();
                                await FirebaseFirestore.instance
                                    .collection("stories")
                                    .doc(storyId)
                                    .set({
                                  'storyid': storyId,
                                  'videourl': videoUrl,
                                  'username': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserName,
                                  'userimage': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserImage,
                                  'useremail': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserEmail,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserId,
                                  'time': Timestamp.now(),
                                }).whenComplete(() async {
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId)
                                      .collection("stories")
                                      .doc(storyId)
                                      .set({
                                    'storyid': storyId,
                                    'videourl': videoUrl,
                                    'username': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .getInitUserName,
                                    'userimage':
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .getInitUserImage,
                                    'useremail':
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .getInitUserEmail,
                                    'useruid': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserId,
                                    'time': Timestamp.now(),
                                  }).whenComplete(() {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: SplitPages(),
                                            type: PageTransitionType
                                                .rightToLeft));
                                  });
                                });
                              } catch (e) {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "Error",
                                  text: e.toString(),
                                );
                              }
                            });
                          },
                          // onPressed: () async {
                          //   await Provider.of<StoriesHelper>(context,
                          //           listen: false)
                          //       .uploadStoryImage(context: context)
                          //       .whenComplete(() async {
                          //     try {
                          //       if (Provider.of<StoriesHelper>(context,
                          //                   listen: false)
                          //               .getStoryImageUrl !=
                          //           null) {
                          //         String storyId = nanoid(14).toString();
                          //         await FirebaseFirestore.instance
                          //             .collection("stories")
                          //             .doc(storyId)
                          //             .set({
                          //           'storyid': storyId,
                          //           'image': Provider.of<StoriesHelper>(context,
                          //                   listen: false)
                          //               .getStoryImageUrl,
                          //           'username': Provider.of<FirebaseOperations>(
                          //                   context,
                          //                   listen: false)
                          //               .getInitUserName,
                          //           'userimage':
                          //               Provider.of<FirebaseOperations>(context,
                          //                       listen: false)
                          //                   .getInitUserImage,
                          //           'useremail':
                          //               Provider.of<FirebaseOperations>(context,
                          //                       listen: false)
                          //                   .getInitUserEmail,
                          //           'useruid': Provider.of<Authentication>(
                          //                   context,
                          //                   listen: false)
                          //               .getUserId,
                          //           'time': Timestamp.now(),
                          //         }).whenComplete(() async {
                          //           await FirebaseFirestore.instance
                          //               .collection("users")
                          //               .doc(Provider.of<Authentication>(
                          //                       context,
                          //                       listen: false)
                          //                   .getUserId)
                          //               .collection("stories")
                          //               .doc(storyId)
                          //               .set({
                          //             'storyid': storyId,
                          //             'image': Provider.of<StoriesHelper>(
                          //                     context,
                          //                     listen: false)
                          //                 .getStoryImageUrl,
                          //             'username':
                          //                 Provider.of<FirebaseOperations>(
                          //                         context,
                          //                         listen: false)
                          //                     .getInitUserName,
                          //             'userimage':
                          //                 Provider.of<FirebaseOperations>(
                          //                         context,
                          //                         listen: false)
                          //                     .getInitUserImage,
                          //             'useremail':
                          //                 Provider.of<FirebaseOperations>(
                          //                         context,
                          //                         listen: false)
                          //                     .getInitUserEmail,
                          //             'useruid': Provider.of<Authentication>(
                          //                     context,
                          //                     listen: false)
                          //                 .getUserId,
                          //             'time': Timestamp.now(),
                          //           }).whenComplete(() {
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 PageTransition(
                          //                     child: HomePage(),
                          //                     type: PageTransitionType
                          //                         .rightToLeft));
                          //           });
                          //         });
                          //       } else {
                          //         CoolAlert.show(
                          //           context: context,
                          //           type: CoolAlertType.error,
                          //           title: "Error uploading image",
                          //           text: "Try again?",
                          //           showCancelBtn: true,
                          //           cancelBtnText: "No",
                          //           confirmBtnText: "Yes",
                          //           onCancelBtnTap: () =>
                          //               Navigator.pop(context),
                          //           onConfirmBtnTap: () async {
                          //             String storyId = nanoid(14).toString();
                          //             await FirebaseFirestore.instance
                          //                 .collection("stories")
                          //                 .doc(storyId)
                          //                 .set({
                          //               'storyid': storyId,
                          //               'image': Provider.of<StoriesHelper>(
                          //                       context,
                          //                       listen: false)
                          //                   .getStoryImageUrl,
                          //               'username':
                          //                   Provider.of<FirebaseOperations>(
                          //                           context,
                          //                           listen: false)
                          //                       .getInitUserName,
                          //               'userimage':
                          //                   Provider.of<FirebaseOperations>(
                          //                           context,
                          //                           listen: false)
                          //                       .getInitUserImage,
                          //               'useremail':
                          //                   Provider.of<FirebaseOperations>(
                          //                           context,
                          //                           listen: false)
                          //                       .getInitUserEmail,
                          //               'useruid': Provider.of<Authentication>(
                          //                       context,
                          //                       listen: false)
                          //                   .getUserId,
                          //               'time': Timestamp.now(),
                          //             }).whenComplete(() async {
                          //               await FirebaseFirestore.instance
                          //                   .collection("users")
                          //                   .doc(Provider.of<Authentication>(
                          //                           context,
                          //                           listen: false)
                          //                       .getUserId)
                          //                   .collection("stories")
                          //                   .doc(storyId)
                          //                   .set({
                          //                 'storyid': storyId,
                          //                 'image': Provider.of<StoriesHelper>(
                          //                         context,
                          //                         listen: false)
                          //                     .getStoryImageUrl,
                          //                 'username':
                          //                     Provider.of<FirebaseOperations>(
                          //                             context,
                          //                             listen: false)
                          //                         .getInitUserName,
                          //                 'userimage':
                          //                     Provider.of<FirebaseOperations>(
                          //                             context,
                          //                             listen: false)
                          //                         .getInitUserImage,
                          //                 'useremail':
                          //                     Provider.of<FirebaseOperations>(
                          //                             context,
                          //                             listen: false)
                          //                         .getInitUserEmail,
                          //                 'useruid':
                          //                     Provider.of<Authentication>(
                          //                             context,
                          //                             listen: false)
                          //                         .getUserId,
                          //                 'time': Timestamp.now(),
                          //               }).whenComplete(() {
                          //                 Navigator.pushReplacement(
                          //                     context,
                          //                     PageTransition(
                          //                         child: HomePage(),
                          //                         type: PageTransitionType
                          //                             .rightToLeft));
                          //               });
                          //             });
                          //           },
                          //         );
                          //       }
                          //     } catch (e) {
                          //       CoolAlert.show(
                          //         context: context,
                          //         type: CoolAlertType.error,
                          //         title: "Error",
                          //         text: e.toString(),
                          //       );
                          //     }
                          //   });
                          // },
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

  addToHighlights(
      {required BuildContext context,
      required String storyImage,
      required String storyId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12),
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
                  Text(
                    "Add to Existing Highlights",
                    style: TextStyle(
                      color: constantColors.yellowColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    "Create New Highlight",
                    style: TextStyle(
                      color: constantColors.yellowColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: storyImage,
                            progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                LoadingWidget(constantColors: constantColors),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: storyHighlightTitleController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "Highlight Title...",
                              hintStyle: TextStyle(
                                color: constantColors.blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: constantColors.blueColor,
                          onPressed: () {
                            if (storyHighlightTitleController.text.isNotEmpty) {
                              String highlightId = nanoid(14).toString();
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .addStoryToNewHighlight(
                                      context: context,
                                      userUid: Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserId,
                                      highLightName:
                                          storyHighlightTitleController.text,
                                      storyImage: storyImage,
                                      storyId: storyId,
                                      highlightId: highlightId);
                            } else {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.warning,
                                title: "Highlight Title Missing",
                                text: "Please Add A Title For Your Highlight",
                              );
                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: constantColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
