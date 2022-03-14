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
                                              .deletePostData(
                                            userUid:
                                                postDocSnap.data!['useruid'],
                                            postId: postId,
                                          );
                                        },
                                        onCancelBtnTap: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
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
      print('11111111111111111');
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
      print('22222222222222222');

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
      print('333333333333333333');

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

  showAwardsPresenter({required BuildContext context, required String postId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                      "Awards",
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
                        .collection('posts')
                        .doc(postId)
                        .collection("awards")
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, awardSnaps) {
                      return ListView(
                        children: awardSnaps.data!.docs.map(
                          (DocumentSnapshot awardDocSnap) {
                            return InkWell(
                              onTap: () {
                                if (awardDocSnap['useruid'] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: awardDocSnap['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                }
                              },
                              child: ListTile(
                                leading: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: awardDocSnap['userimage'],
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          LoadingWidget(
                                              constantColors: constantColors),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserId ==
                                        awardDocSnap['useruid']
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
                                title: Text(
                                  awardDocSnap['username'],
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
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

  showLikes({required BuildContext context, required likes}) {
    return showModalBottomSheet(
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
                Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        children: likes.map<Widget>((likesItem) {
                          return ListTile(
                            leading: InkWell(
                              onTap: () {
                                if (likesItem['useruid'] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: likesItem['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                }
                              },
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: likesItem['userimage'],
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
                            title: Text(
                              likesItem['username'],
                              style: TextStyle(
                                color: constantColors.blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              likesItem['useremail'],
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId ==
                                    likesItem['useruid']
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
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showRewards({
    required BuildContext context,
    required String postId,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
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
                      "Rewards",
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("awards")
                          .snapshots(),
                      builder: (context, awardSnap) {
                        if (awardSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                              scrollDirection: Axis.horizontal,
                              children: awardSnap.data!.docs
                                  .map<Widget>((DocumentSnapshot awardDocSnap) {
                                return InkWell(
                                  onTap: () async {
                                    if (Provider.of<Authentication>(context,
                                                listen: false)
                                            .getIsAnon ==
                                        false) {
                                      await Provider.of<FirebaseOperations>(
                                              context,
                                              listen: false)
                                          .addAward(postId: postId, data: {
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
                                        'useruid': Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserId,
                                        'time': Timestamp.now(),
                                        'award': awardDocSnap['image'],
                                      });
                                    } else {
                                      IsAnonBottomSheet(context);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.network(awardDocSnap['image']),
                                    ),
                                  ),
                                );
                              }).toList());
                        }
                      },
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
}