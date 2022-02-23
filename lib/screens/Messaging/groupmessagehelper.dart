import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/services/fcm_notification_Service.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper with ChangeNotifier {
  bool hasMemberJoined = false;
  bool get getHasMemberJoined => hasMemberJoined;
  ConstantColors constantColors = ConstantColors();
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  leaveTheRoom(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      backgroundColor: constantColors.darkColor,
      title: "Exit ${documentSnapshot['roomname']}?",
      text: "Are you sure you want to leave the group chat?",
      showCancelBtn: true,
      cancelBtnText: "No",
      confirmBtnText: "Yes",
      onCancelBtnTap: () => Navigator.pop(context),
      onConfirmBtnTap: () {
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(documentSnapshot.id)
            .collection("members")
            .doc(Provider.of<Authentication>(context, listen: false).getUserId)
            .delete()
            .whenComplete(() {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: SplitPages(), type: PageTransitionType.bottomToTop));
        });
      },
    );
  }

  showMessages(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot,
      required String adminUserUid}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(documentSnapshot.id)
          .collection("messages")
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, messageSnaps) {
        if (messageSnaps.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return StatefulBuilder(builder: (context, state) {
            return ListView(
              reverse: true,
              children: messageSnaps.data!.docs.map((DocumentSnapshot msgSnap) {
                return Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.05,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Stack(
                    children: [
                      InkWell(
                        onLongPress: () {
                          if (Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId ==
                              msgSnap['useruid']) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.warning,
                              title: "Delete Message?",
                              text:
                                  "Are you sure you want to delete this messsage?",
                              cancelBtnText: "No",
                              showCancelBtn: true,
                              confirmBtnText: "Yes",
                              onCancelBtnTap: () => Navigator.pop(context),
                              onConfirmBtnTap: () {
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .deleteMessage(
                                        chatroomId: documentSnapshot.id,
                                        messageId: msgSnap.id)
                                    .whenComplete(() {
                                  Navigator.pop(context);
                                });
                              },
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserId ==
                                    msgSnap['useruid']
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  constraints: BoxConstraints(
                                    // maxHeight:
                                    //     MediaQuery.of(context).size.height * 0.13,
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserId ==
                                            msgSnap['useruid']
                                        ? constantColors.blueColor
                                            .withOpacity(0.8)
                                        : constantColors.blueGreyColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Row(
                                            children: [
                                              Text(
                                                msgSnap['username'],
                                                style: TextStyle(
                                                  color:
                                                      constantColors.greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Provider.of<Authentication>(
                                                              context,
                                                              listen: false)
                                                          .getUserId ==
                                                      msgSnap['useruid']
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .chessKing,
                                                        color: constantColors
                                                            .yellowColor,
                                                        size: 12,
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                            ],
                                          ),
                                        ),
                                        msgSnap['message'].toString().isNotEmpty
                                            ? Text(
                                                msgSnap['message'],
                                                style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                  msgSnap['sticker'],
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: SizedBox(
                                            width: 80,
                                            child: Text(
                                              timeago.format(
                                                  (msgSnap['time'] as Timestamp)
                                                      .toDate()),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          });
        }
      },
    );
  }

  sendMessage(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot,
      required TextEditingController messagecontroller,
      required String messageId}) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(documentSnapshot.id)
        .collection("messages")
        .doc(messageId)
        .set({
      'messageid': messageId,
      'message': messagecontroller.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
    });
  }

  updateTime({
    required DocumentSnapshot documentSnapshot,
  }) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(documentSnapshot.id)
        .update({
      'time': Timestamp.now(),
    });
  }

  Future checkIfJoined(
      {required BuildContext context,
      required String chatroomId,
      required String chatroomAdminUid}) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("members")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((value) {
      hasMemberJoined = false;
      // print("Inital state  => $hasMemberJoined");
      if (value['joined'] != null) {
        hasMemberJoined = value['joined'];
        // print("Final state => $hasMemberJoined");
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserId ==
          chatroomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(
      {required BuildContext context,
      required String roomname,
      required String chatroomId}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            "Join $roomname",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: SplitPages(),
                        type: PageTransitionType.bottomToTop));
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MaterialButton(
              color: constantColors.greenColor,
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(chatroomId)
                    .collection("members")
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserId)
                    .set({
                  'joined': true,
                  'username':
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getInitUserName,
                  'userimage':
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getInitUserImage,
                  'useremail':
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getInitUserEmail,
                  'useruid': Provider.of<Authentication>(context, listen: false)
                      .getUserId,
                  'fcmToken':
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getFcmToken,
                  'time': Timestamp.now(),
                }).whenComplete(() async {
                  await FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(chatroomId)
                      .get()
                      .then((chatroomDoc) async {
                    await FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(chatroomId)
                        .collection("members")
                        .orderBy('time', descending: true)
                        .get()
                        .then((memberDocs) {
                      memberDocs.docs.forEach((memberDoc) async {
                        await _fcmNotificationService.sendNotificationToUser(
                            to: memberDoc['fcmToken']!, //To change once set up
                            title: "New member | ${chatroomDoc['roomname']}",
                            body:
                                "${memberDocs.docs[0]['username']} has joined the group chat");
                      });
                    });
                  });
                }).whenComplete(() {
                  Navigator.pop(context);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showSticker({
    required BuildContext context,
    required String chatroomId,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 105.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: constantColors.blueColor,
                          ),
                        ),
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/icons/sunflower.png"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("stickers")
                        .snapshots(),
                    builder: (context, stickerSnaps) {
                      if (!stickerSnaps.hasData) {
                        return Center(
                          child: Text(
                            "No Stickers Available",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      } else {
                        return GridView(
                          children: stickerSnaps.data!.docs.map(
                            (stickerDocSnap) {
                              return InkWell(
                                onTap: () {
                                  String messageId = nanoid(14).toString();
                                  sendSticker(
                                      context: context,
                                      stickerImageUrl: stickerDocSnap['image'],
                                      chatroomid: chatroomId,
                                      messageId: messageId);
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Image.network(
                                    stickerDocSnap['image'],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
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

  sendSticker({
    required BuildContext context,
    required String stickerImageUrl,
    required String chatroomid,
    required String messageId,
  }) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomid)
        .collection("messages")
        .doc(messageId)
        .set({
      'messageid': messageId,
      'message': "",
      'sticker': stickerImageUrl,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }
}
