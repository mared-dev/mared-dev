import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/promotePost/promotePostHelper.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/fcm_notification_Service.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();
  late String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;
  TextEditingController updateDescriptionController = TextEditingController();

  getImageDescription(dynamic description) {
    updateDescriptionController.text = description;
  }

  showTimeAgo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);

    notifyListeners();
  }

  showPostOptions({required BuildContext context, required String postId}) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
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
                      .collection("posts")
                      .doc(postId)
                      .snapshots(),
                  builder: (context, postDocSnap) {
                    if (postDocSnap.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    color: constantColors.blueColor,
                                    child: Text("Edit Caption",
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                    onPressed: () {
                                      editCaptionText(
                                          context, postDocSnap, postId);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    color: constantColors.redColor,
                                    child: Text("Delete Post",
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                    onPressed: () {
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        confirmBtnText: "Delete",
                                        cancelBtnText: "Keep Post",
                                        showCancelBtn: true,
                                        title: "Delete this post?",
                                        onConfirmBtnTap: () async {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          // Navigator.of(context).pop();
                                          Navigator.of(context).pop();

                                          await Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .deletePostData(
                                            userUid:
                                                postDocSnap.data!['useruid'],
                                            postId: postId,
                                          );
                                        },
                                        onCancelBtnTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      color: constantColors.greenColor,
                                      child: Text("Promote Post",
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      onPressed: () {
                                        Provider.of<PromotePostHelper>(context,
                                                listen: false)
                                            .promotionBottomSheet(context, size,
                                                postDocSnap.data!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> editCaptionText(BuildContext context,
      AsyncSnapshot<DocumentSnapshot<Object?>> postDocSnap, String postId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: TextField(
                              maxLines: 5,
                              controller: updateDescriptionController,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: constantColors.greenColor,
                          child: Icon(
                            FontAwesomeIcons.fileUpload,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .updateDescription(
                                    postDoc: postDocSnap,
                                    context: context,
                                    postId: postId,
                                    description:
                                        updateDescriptionController.text)
                                .whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
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
  }

  Future addLike({
    required BuildContext context,
    required String postID,
    required String subDocId,
    required String userUid,
  }) async {
    var post =
        await FirebaseFirestore.instance.collection('posts').doc(postID).get();

    //fix this
    UserModel userModel = UserInfoManger.getUserInfo();

    if (post
        .data()!['likes']
        .any((element) => element['useruid'] == userModel.uid)) {
      var newLikesList = [];
      var likesList = post.data()!['likes'];
      for (var i = 0; i < likesList.length; i++) {
        if (likesList[i]['useruid'] != userModel.uid) {
          newLikesList.add(likesList[i]);
        }
      }

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .update({'likes': newLikesList});
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection('posts')
          .doc(postID)
          .update({'likes': newLikesList});
    } else {
      await FirebaseFirestore.instance.collection('posts').doc(postID).update({
        'likes': [
          ...post.data()!['likes'],
          {
            'username': userModel.userName,
            'useruid': userModel.uid,
            'userimage': userModel.photoUrl,
            'useremail': userModel.email,
            'time': Timestamp.now(),
          }
        ]
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection('posts')
          .doc(postID)
          .update({
        'likes': [
          ...post.data()!['likes'],
          {
            'username': userModel.userName,
            'useruid': userModel.uid,
            'userimage': userModel.photoUrl,
            'useremail': userModel.email,
            'time': Timestamp.now(),
          }
        ]
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .get()
          .then((postUser) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(subDocId)
            .get()
            .then((likingUser) async {
          await _fcmNotificationService.sendNotificationToUser(
              to: postUser['fcmToken']!, //To change once set up
              title: "${likingUser['username']} liked your post",
              body: "");
        });
      });
    }
  }
}
