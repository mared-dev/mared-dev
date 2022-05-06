import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/config.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/general_styles.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/feed_models/post_details_model.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/promotePost/promotePostHelper.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/fcm_notification_Service.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:mared_social/widgets/reusable/bottom_sheet_top_divider.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();
  late String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;
  TextEditingController updateDescriptionController = TextEditingController();
  TextEditingController updateTitleController = TextEditingController();

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
                                          context,
                                          PostDetailsModel.fromjson(
                                              postDocSnap),
                                          postId);
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

  Future<dynamic> editCaptionText(
      BuildContext context, PostDetailsModel postDetailsModel, String postId) {
    updateDescriptionController.text = postDetailsModel.description;
    updateTitleController.text = postDetailsModel.caption;
    return showModalBottomSheet(
      //to show it on top of the persistent bottom navbar and its components
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.commentButtonColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                BottomSheetTopDivider(),
                SizedBox(
                  height: 34.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.w),
                  child: TextField(
                    maxLines: 1,
                    controller: updateTitleController,
                    decoration: getAuthInputDecoration(
                      verticalContentPadding: 11.h,
                      hintText: 'Title',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 38.w, vertical: 25.h),
                  child: TextField(
                    maxLines: 3,
                    minLines: 3,
                    controller: updateDescriptionController,
                    decoration: getAuthInputDecoration(
                      verticalContentPadding: 11.h,
                      hintText: 'Description',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .updateDescription(
                            postDetailsModel: postDetailsModel,
                            context: context,
                            postId: postId,
                            title: updateTitleController.text,
                            description: updateDescriptionController.text)
                        .whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 14.h),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      primary: AppColors.accentColor),
                  child: Text('Save changes'),
                ),
              ],
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
