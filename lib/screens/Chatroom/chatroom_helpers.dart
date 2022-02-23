import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/Messaging/groupmessage.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelpers with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  ConstantColors constantColors = ConstantColors();
  late String chatroomAvatarUrl = "";
  late String chatroomId;

  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  String get getChatroomId => chatroomId;
  TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.27,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.blueColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Members",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: constantColors.transperant,
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(documentSnapshot.id)
                        .collection("members")
                        .snapshots(),
                    builder: (context, memberSnaps) {
                      if (!memberSnaps.hasData) {
                        return Center(
                          child: Text(
                            "No Members Yet",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: memberSnaps.data!.docs.map((memberDocSnap) {
                            return InkWell(
                              onTap: () {
                                if (memberDocSnap['useruid'] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: memberDocSnap['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(memberDocSnap['userimage']),
                                  backgroundColor: constantColors.darkColor,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.yellowColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Admins",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          backgroundImage: NetworkImage(
                            documentSnapshot['userimage'],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Provider.of<Authentication>(context, listen: false)
                                        .getUserId ==
                                    documentSnapshot['useruid']
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: MaterialButton(
                                      color: constantColors.redColor,
                                      child: Text(
                                        "Delete Chat",
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.warning,
                                          backgroundColor:
                                              constantColors.darkColor,
                                          title:
                                              "Delete ${documentSnapshot['roomname']}?",
                                          text:
                                              "Are you sure you want to delete the group chat?",
                                          showCancelBtn: true,
                                          cancelBtnText: "No",
                                          confirmBtnText: "Yes",
                                          onCancelBtnTap: () =>
                                              Navigator.pop(context),
                                          onConfirmBtnTap: () {
                                            FirebaseFirestore.instance
                                                .collection("chatrooms")
                                                .doc(documentSnapshot.id)
                                                .delete()
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                    width: 0,
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
        );
      },
    );
  }

  showCreateChatroomSheet({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: StatefulBuilder(builder: (context, stateSetter) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
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
                      Text(
                        "Select Chatroom Avatar",
                        style: TextStyle(
                          color: constantColors.greenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("chatroomIcons")
                              .snapshots(),
                          builder: (context, chatroomIconSnaps) {
                            if (!chatroomIconSnaps.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: chatroomIconSnaps.data!.docs
                                    .map((DocumentSnapshot documentSnapshot) {
                                  return InkWell(
                                    onTap: () {
                                      stateSetter(() {
                                        chatroomAvatarUrl =
                                            documentSnapshot['image'];
                                      });
                                      chatroomAvatarUrl =
                                          documentSnapshot['image'];
                                      notifyListeners();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: getChatroomAvatarUrl ==
                                                    documentSnapshot['image']
                                                ? constantColors.blueColor
                                                : constantColors.transperant,
                                          ),
                                        ),
                                        height: 15,
                                        width: 45,
                                        child: Image.network(
                                            documentSnapshot['image'],
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                validator: (value) => value!.isEmpty
                                    ? 'Field cannot be blank'
                                    : null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: chatroomNameController,
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter Chatroom ID",
                                  hintStyle: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String chatroomIdName = nanoid(14).toString();
                                  Provider.of<FirebaseOperations>(context,
                                          listen: false)
                                      .submitChatroomData(
                                    chatroomName: chatroomIdName,
                                    chatroomData: {
                                      'chatroomid': chatroomIdName,
                                      'roomAvatar': getChatroomAvatarUrl,
                                      'time': Timestamp.now(),
                                      'roomname': chatroomNameController.text,
                                      'username':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserName,
                                      'userimage':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserImage,
                                      'useremail':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserEmail,
                                      'useruid': Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserId,
                                    },
                                  ).whenComplete(() {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              backgroundColor: constantColors.darkColor,
                              child: Icon(
                                FontAwesomeIcons.plus,
                                color: constantColors.yellowColor,
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
          }),
        );
      },
    );
  }

  showChatrooms({required BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chatrooms")
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, chatroomSnaps) {
        if (!chatroomSnaps.hasData) {
          return Center(
            child: LoadingWidget(constantColors: constantColors),
          );
        } else {
          return ListView(
            children: chatroomSnaps.data!.docs
                .map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child:
                              GroupMessage(documentSnapshot: documentSnapshot),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {
                  showChatroomDetails(
                      context: context, documentSnapshot: documentSnapshot);
                },
                title: Text(
                  documentSnapshot['roomname'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  timeago
                      .format((documentSnapshot['time'] as Timestamp).toDate()),
                  style: TextStyle(
                    color: constantColors.greenColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(documentSnapshot.id)
                        .collection("messages")
                        .orderBy('time', descending: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return Text(
                            snapshot.data!.docs[0]['message']
                                    .toString()
                                    .isNotEmpty
                                ? "${snapshot.data!.docs[0]['username']}: ${snapshot.data!.docs[0]['message']}"
                                : "${snapshot.data!.docs[0]['username']}: Sticker",
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontSize: 10,
                            ),
                          );
                        } else {
                          return Text(
                            "",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 10,
                            ),
                          );
                        }
                      } catch (e) {
                        return Center(
                          child: Text(e.toString()),
                        );
                      }
                    }),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: NetworkImage(documentSnapshot['roomAvatar']),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget bottomNavBar({
    required BuildContext context,
    required int index,
    required PageController pageController,
  }) {
    return CustomNavigationBar(
        currentIndex: index,
        bubbleCurve: Curves.bounceIn,
        scaleCurve: Curves.decelerate,
        selectedColor: constantColors.blueColor,
        unSelectedColor: constantColors.whiteColor,
        strokeColor: constantColors.blueColor,
        scaleFactor: 0.5,
        iconSize: 30,
        onTap: (val) {
          index = val;
          pageController.jumpToPage(
            index,
          );
          notifyListeners();
        },
        backgroundColor: const Color(0xff040307),
        items: [
          CustomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.users),
            title: Text(
              "Group Chat",
              style: TextStyle(
                color: constantColors.whiteColor,
              ),
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.userFriends),
            title: Text(
              "Private Chat",
              style: TextStyle(
                color: constantColors.whiteColor,
              ),
            ),
          ),
        ]);
  }
}
