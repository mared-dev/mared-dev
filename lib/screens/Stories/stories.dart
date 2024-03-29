import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/Stories/stories_helper.dart';
import 'package:mared_social/screens/Stories/stories_widget.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../Profile/profile.dart';

class Stories extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> querySnapshot;
  int snapIndex;

  Stories({Key? key, required this.querySnapshot, required this.snapIndex})
      : super(key: key);
  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();
  CountDownController countDownController = CountDownController();
  int indexCheck = 0;
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        widget.querySnapshot.data!.docs[widget.snapIndex]['videourl'])
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller!.play();
        _controller!.addListener(checkVideo);
      });
    setState(() {
      indexCheck = widget.snapIndex;
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: SafeArea(
        child: GestureDetector(
          onLongPressEnd: (details) {
            _controller!.play();
          },
          onPanUpdate: (update) {
            if (update.delta.dx > 0) {
              Navigator.of(context).pop();
            }
          },
          onLongPress: () {
            _controller!.pause();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: _controller!.value.isInitialized
                              ? Center(
                                  child: AspectRatio(
                                    aspectRatio: _controller!.value.size.width /
                                        _controller!.value.size.height,
                                    child: SizedBox(
                                      height: _controller!.value.size.height,
                                      width: _controller!.value.size.width,
                                      child: VideoPlayer(
                                        _controller!,
                                      ),
                                    ),
                                  ),
                                )
                              : LoadingWidget(constantColors: constantColors),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: () async {
                    if (indexCheck ==
                        widget.querySnapshot.data!.docs.length - 1) {
                      _controller!.dispose();
                      Navigator.of(context).pop();
                    } else {
                      _controller!.dispose();
                      setState(() {
                        indexCheck = indexCheck + 1;
                      });

                      _controller = await VideoPlayerController.network(widget
                          .querySnapshot.data!.docs[indexCheck]['videourl'])
                        ..initialize().then((_) {
                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                          setState(() {});
                          _controller!.play();
                        });
                    }
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: InkWell(
                  onTap: () async {
                    if (indexCheck == 0) {
                      _controller!.dispose();
                      Navigator.of(context).pop();
                    } else {
                      _controller!.dispose();
                      setState(() {
                        indexCheck = indexCheck - 1;
                      });

                      _controller = VideoPlayerController.network(widget
                          .querySnapshot.data!.docs[indexCheck]['videourl'])
                        ..initialize().then((_) {
                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                          setState(() {});
                          _controller!.play();
                        });
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.querySnapshot.data!.docs[widget.snapIndex]
                                  ['useruid'] !=
                              UserInfoManger.getUserId()) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userModel: UserModel(
                                          phoneNumber: GeneralFirebaseHelpers.getStringSafely(
                                              key: 'usercontactnumber',
                                              doc: widget.querySnapshot.data!
                                                  .docs[indexCheck]),
                                          websiteLink:
                                              GeneralFirebaseHelpers.getStringSafely(
                                                  key: 'websiteLink',
                                                  doc: widget.querySnapshot
                                                      .data!.docs[indexCheck]),
                                          postCategory:
                                              GeneralFirebaseHelpers.getStringSafely(
                                                  key: 'postcategory',
                                                  doc: widget.querySnapshot
                                                      .data!.docs[indexCheck]),
                                          bio: GeneralFirebaseHelpers.getStringSafely(
                                              key: 'bio',
                                              doc: widget.querySnapshot.data!
                                                  .docs[indexCheck]),
                                          address: GeneralFirebaseHelpers.getStringSafely(
                                              key: 'address',
                                              doc: widget.querySnapshot.data!.docs[indexCheck]),
                                          geoPoint: GeneralFirebaseHelpers.getGeoPointSafely(key: 'geoPoint', doc: widget.querySnapshot.data!.docs[indexCheck]),
                                          uid: widget.querySnapshot.data!.docs[indexCheck]['useruid'],
                                          userName: widget.querySnapshot.data!.docs[indexCheck]['username'],
                                          photoUrl: widget.querySnapshot.data!.docs[indexCheck]['userimage'],
                                          email: widget.querySnapshot.data!.docs[indexCheck]['useremail'],
                                          fcmToken: "",

                                          ///later you have to give this the right value
                                          store: false),
                                      userUid: widget.querySnapshot.data!
                                          .docs[indexCheck]['useruid'],
                                    ),
                                    type: PageTransitionType.rightToLeft));
                          } else {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Profile(),
                                    type: PageTransitionType.rightToLeft));
                          }
                        },
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget.querySnapshot.data!
                                  .docs[indexCheck]['userimage'],
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  LoadingWidget(constantColors: constantColors),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.querySnapshot.data!.docs[indexCheck]
                                    ['username'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                timeago.format((widget.querySnapshot.data!
                                        .docs[indexCheck]['time'] as Timestamp)
                                    .toDate()),
                                style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: UserInfoManger.getUserId() ==
                            widget.querySnapshot.data!.docs[indexCheck]
                                ['useruid'],
                        child: InkWell(
                          onTap: () {},
                          child: SizedBox(
                            height: 30,
                            width: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidEye,
                                  color: constantColors.yellowColor,
                                  size: 16,
                                ),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                bottom: true,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: constantColors.blueGreyColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 150),
                                        child: Divider(
                                          thickness: 4,
                                          color: constantColors.whiteColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      constantColors.blueColor),
                                            ),
                                            icon: Icon(
                                              FontAwesomeIcons.archive,
                                              color: constantColors.whiteColor,
                                            ),
                                            onPressed: () {
                                              storyWidgets.addToHighlights(
                                                context: context,
                                                storyImage: widget
                                                        .querySnapshot
                                                        .data!
                                                        .docs[widget.snapIndex]
                                                    ['image'],
                                                storyId: widget
                                                    .querySnapshot
                                                    .data!
                                                    .docs[widget.snapIndex]
                                                    .id,
                                              );
                                            },
                                            label: Text(
                                              "Add to highlights",
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          TextButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      constantColors.redColor),
                                            ),
                                            icon: Icon(
                                              FontAwesomeIcons.trashAlt,
                                              color: constantColors.whiteColor,
                                            ),
                                            onPressed: () {
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.warning,
                                                title: "Delete Story?",
                                                text:
                                                    "Are you sure you want to delete this story?",
                                                showCancelBtn: true,
                                                cancelBtnText: "No",
                                                confirmBtnText: "Yes",
                                                onCancelBtnTap: () =>
                                                    Navigator.pop(context),
                                                onConfirmBtnTap: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("stories")
                                                        .doc(widget
                                                            .querySnapshot
                                                            .data!
                                                            .docs[widget
                                                                .snapIndex]
                                                            .id)
                                                        .delete()
                                                        .whenComplete(() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("users")
                                                          .doc(Provider.of<
                                                                      Authentication>(
                                                                  context,
                                                                  listen: false)
                                                              .getUserId)
                                                          .collection("stories")
                                                          .doc(widget
                                                              .querySnapshot
                                                              .data!
                                                              .docs[widget
                                                                  .snapIndex]
                                                              .id)
                                                          .delete()
                                                          .whenComplete(() {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    });
                                                  } catch (e) {
                                                    CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.error,
                                                      title:
                                                          "Delete Story Failed",
                                                      text: e.toString(),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                            label: Text(
                                              "Delete Story",
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          EvaIcons.moreVertical,
                          color: constantColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkVideo() {
    while (_controller!.value.position == _controller!.value.duration) {
      if (indexCheck == widget.querySnapshot.data!.docs.length - 1) {
        _controller!.dispose();
        Navigator.of(context).pop();
      }

      _controller!.dispose();
      setState(() {
        indexCheck = indexCheck + 1;
      });

      _controller = VideoPlayerController.network(
          widget.querySnapshot.data!.docs[indexCheck]['videourl'])
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
          _controller!.play();
        });
      break;
    }
  }
}
