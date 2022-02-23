import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/services/fcm_notification_Service.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class AuctionFuctions with ChangeNotifier {
  TextEditingController auctionCommentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();
  late String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;
  TextEditingController updateAuctionDescriptionController =
      TextEditingController();

  getImageDescription(dynamic description) {
    updateAuctionDescriptionController.text = description;
  }

  showTimeAgo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);

    notifyListeners();
  }

  showAuctionOptions(
      {required BuildContext context, required String auctionId}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
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
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("auctions")
                        .doc(auctionId)
                        .snapshots(),
                    builder: (context, auctionDocSnap) {
                      if (auctionDocSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              color: constantColors.blueColor,
                              child: Text("Edit Caption",
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SafeArea(
                                      bottom: true,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
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
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
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
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                              ),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: SizedBox(
                                                        width: 300,
                                                        height: 50,
                                                        child: TextField(
                                                          maxLines: 5,
                                                          controller:
                                                              updateAuctionDescriptionController,
                                                          style: TextStyle(
                                                            color:
                                                                constantColors
                                                                    .whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    FloatingActionButton(
                                                      backgroundColor:
                                                          constantColors
                                                              .greenColor,
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .fileUpload,
                                                        color: constantColors
                                                            .whiteColor,
                                                      ),
                                                      onPressed: () {
                                                        Provider.of<FirebaseOperations>(
                                                                context,
                                                                listen: false)
                                                            .updateAuctionDescription(
                                                                auctionDoc:
                                                                    auctionDocSnap,
                                                                context:
                                                                    context,
                                                                auctionId:
                                                                    auctionId,
                                                                description:
                                                                    updateAuctionDescriptionController
                                                                        .text)
                                                            .whenComplete(() {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
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
                              },
                            ),
                            MaterialButton(
                              color: constantColors.redColor,
                              child: Text("Delete Post",
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              onPressed: () {
                                // Navigator.pop(context);
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.warning,
                                  confirmBtnText: "Delete",
                                  cancelBtnText: "Keep Post",
                                  showCancelBtn: true,
                                  title: "Delete this post?",
                                  onConfirmBtnTap: () async {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    await Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .deleteAuctionData(
                                      userUid: auctionDocSnap.data!['useruid'],
                                      auctionId: auctionId,
                                    );
                                  },
                                  onCancelBtnTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future addAuctionLike({
    required BuildContext context,
    required String auctionID,
    required String subDocId,
    required String userUid,
  }) async {
    return FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionID)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection('auctions')
          .doc(auctionID)
          .collection('likes')
          .doc(subDocId)
          .set({
        'likes': FieldValue.increment(1),
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserId,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
        'useremail': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserEmail,
        'time': Timestamp.now(),
      }).whenComplete(() async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userUid)
            .get()
            .then((auctionUser) async {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(subDocId)
              .get()
              .then((likingUser) async {
            await _fcmNotificationService.sendNotificationToUser(
                to: auctionUser['fcmToken']!, //To change once set up
                title: "${likingUser['username']} liked your auction",
                body: "");
          });
        });
      });
    });
  }

  Future addAuctionView({
    required BuildContext context,
    required String auctionID,
    required String subDocId,
    required String userUid,
  }) async {
    return FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionID)
        .collection('views')
        .doc(subDocId)
        .set({
      'views': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection('auctions')
          .doc(auctionID)
          .collection('views')
          .doc(subDocId)
          .set({
        'views': FieldValue.increment(1),
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserId,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
        'useremail': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserEmail,
        'time': Timestamp.now(),
      });
    });
  }

  Future addAuctionComment({
    required String userUid,
    required String auctionId,
    required String comment,
    required BuildContext context,
  }) async {
    String commentId = nanoid(14).toString();
    await FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionId)
        .collection('comments')
        .doc(commentId)
        .set({
      'commentid': commentId,
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .get()
          .then((auctionUser) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(Provider.of<Authentication>(context, listen: false).getUserId)
            .get()
            .then((commentingUser) async {
          await _fcmNotificationService.sendNotificationToUser(
              to: auctionUser['fcmToken']!, //To change once set up
              title: "${commentingUser['username']} commented",
              body: comment);
        });
      });
    });
  }

  showCommentsSheet({
    required BuildContext context,
    required DocumentSnapshot snapshot,
    required String auctionId,
  }) {
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Comments",
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('auctions')
                          .doc(auctionId)
                          .collection("comments")
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, commentSnap) {
                        if (commentSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: commentSnap.data!.docs
                                .map((DocumentSnapshot commentDocSnap) {
                              return Container(
                                color: constantColors.blueGreyColor,
                                height:
                                    MediaQuery.of(context).size.height * 0.135,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              if (commentDocSnap['useruid'] !=
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserId) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        child: AltProfile(
                                                          userUid:
                                                              commentDocSnap[
                                                                  'useruid'],
                                                        ),
                                                        type: PageTransitionType
                                                            .bottomToTop));
                                              }
                                            },
                                            child: Container(
                                              // color: constantColors.darkColor,
                                              height: 30,
                                              width: 30,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: commentDocSnap[
                                                      'userimage'],
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          LoadingWidget(
                                                              constantColors:
                                                                  constantColors),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    commentDocSnap['username'],
                                                    style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                  FontAwesomeIcons.arrowUp,
                                                  size: 14,
                                                  color:
                                                      constantColors.blueColor),
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(FontAwesomeIcons.reply,
                                                  size: 14,
                                                  color: constantColors
                                                      .yellowColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: constantColors.blueColor,
                                              size: 14,
                                            ),
                                            onPressed: () {},
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              commentDocSnap['comment'],
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Provider.of<Authentication>(context,
                                                          listen: false)
                                                      .getUserId ==
                                                  commentDocSnap['useruid']
                                              ? IconButton(
                                                  onPressed: () {
                                                    Provider.of<FirebaseOperations>(
                                                            context,
                                                            listen: false)
                                                        .deleteAuctionUserComment(
                                                            auctionId:
                                                                auctionId,
                                                            commentId:
                                                                commentDocSnap[
                                                                    'commentid']);
                                                  },
                                                  icon: Icon(
                                                      FontAwesomeIcons.trashAlt,
                                                      size: 14,
                                                      color: constantColors
                                                          .redColor),
                                                )
                                              : const SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: constantColors.darkColor
                                          .withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300,
                          height: 30,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Add your opnion...',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: auctionCommentController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: constantColors.greenColor,
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            if (Provider.of<Authentication>(context,
                                        listen: false)
                                    .getIsAnon ==
                                false) {
                              addAuctionComment(
                                      userUid: snapshot['useruid'],
                                      auctionId: snapshot['auctionid'],
                                      comment: auctionCommentController.text,
                                      context: context)
                                  .whenComplete(() {
                                auctionCommentController.clear();
                                notifyListeners();
                              });
                            } else {
                              Provider.of<FeedHelpers>(context, listen: false)
                                  .IsAnonBottomSheet(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showLikes({required BuildContext context, required String auctionId}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
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
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Likes",
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("auctions")
                        .doc(auctionId)
                        .collection("likes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: InkWell(
                                onTap: () {
                                  if (documentSnapshot['useruid'] !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId) {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid:
                                                  documentSnapshot['useruid'],
                                            ),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: documentSnapshot['userimage'],
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          LoadingWidget(
                                              constantColors: constantColors),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId ==
                                      documentSnapshot['useruid']
                                  ? const SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                                  : MaterialButton(
                                      child: Text("Follow",
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          )),
                                      onPressed: () {},
                                      color: constantColors.blueColor,
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
