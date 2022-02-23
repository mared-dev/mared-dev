import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

class SeeVideo extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const SeeVideo({Key? key, required this.documentSnapshot}) : super(key: key);
  @override
  _SeeVideoState createState() => _SeeVideoState();
}

class _SeeVideoState extends State<SeeVideo> {
  ConstantColors constantColors = ConstantColors();
  VideoPlayerController? _controller;
  bool? approved;
  bool loading = true;

  finishLoading() async {
    _controller =
        VideoPlayerController.network(widget.documentSnapshot['video']);

    await _controller!.initialize().whenComplete(() async {
      await _controller!.play();
    });
  }

  @override
  void initState() {
    finishLoading();

    setState(() {
      approved = widget.documentSnapshot['approved'];
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (update) {
            if (update.delta.dx > 0) {
              Navigator.pop(context);
            }
          },
          onTap: () {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
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
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VideoPlayer(
                              _controller!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: ValueListenableBuilder(
                  valueListenable: _controller!,
                  builder: (context, VideoPlayerValue value, child) {
                    //Do Something with the value.
                    return value.position.inSeconds < 1
                        ? Center(
                            child:
                                LoadingWidget(constantColors: constantColors),
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userUid:
                                            widget.documentSnapshot['useruid'],
                                      ),
                                      type: PageTransitionType.bottomToTop));
                            },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      widget.documentSnapshot['userimage'],
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          LoadingWidget(
                                              constantColors: constantColors),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.documentSnapshot['username'],
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(
                                          (widget.documentSnapshot['time']
                                                  as Timestamp)
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
                          ),
                          Visibility(
                            visible: widget.documentSnapshot['vendorid'] ==
                                Provider.of<Authentication>(context).getUserId,
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SafeArea(
                                        bottom: true,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: constantColors.blueGreyColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 150),
                                                child: Divider(
                                                  thickness: 4,
                                                  color:
                                                      constantColors.whiteColor,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Visibility(
                                                        visible:
                                                            approved == false,
                                                        replacement:
                                                            ElevatedButton.icon(
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .pink),
                                                          ),
                                                          onPressed: () {
                                                            Provider.of<FirebaseOperations>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .unapproveBrandVideo(
                                                                    context:
                                                                        context,
                                                                    userId: widget
                                                                            .documentSnapshot[
                                                                        'useruid'],
                                                                    vendorId: Provider.of<Authentication>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getUserId,
                                                                    workId: widget
                                                                        .documentSnapshot
                                                                        .id)
                                                                .whenComplete(
                                                                    () {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          icon: Icon(
                                                              FontAwesomeIcons
                                                                  .check),
                                                          label: Text(
                                                            "Unapprove",
                                                          ),
                                                        ),
                                                        child:
                                                            ElevatedButton.icon(
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .pink),
                                                          ),
                                                          onPressed: () {
                                                            Provider.of<FirebaseOperations>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .approveBrandVideo(
                                                                    context:
                                                                        context,
                                                                    userId: widget
                                                                            .documentSnapshot[
                                                                        'useruid'],
                                                                    vendorId: Provider.of<Authentication>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getUserId,
                                                                    workId: widget
                                                                        .documentSnapshot
                                                                        .id)
                                                                .whenComplete(
                                                                    () {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          icon: Icon(
                                                              FontAwesomeIcons
                                                                  .check),
                                                          label: Text(
                                                            "Approve",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          ElevatedButton.icon(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .pink),
                                                        ),
                                                        onPressed: () {
                                                          Provider.of<FirebaseOperations>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteBrandVideo(
                                                                  context:
                                                                      context,
                                                                  userId: widget
                                                                          .documentSnapshot[
                                                                      'useruid'],
                                                                  vendorId: Provider.of<
                                                                              Authentication>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getUserId,
                                                                  workId: widget
                                                                      .documentSnapshot
                                                                      .id)
                                                              .whenComplete(() {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .trash),
                                                        label: Text(
                                                          "Delete",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.more_vert_outlined,
                                  color: constantColors.whiteColor,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.documentSnapshot['description'],
                              style:
                                  TextStyle(color: constantColors.whiteColor),
                            ),
                          ),
                        ],
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
}
