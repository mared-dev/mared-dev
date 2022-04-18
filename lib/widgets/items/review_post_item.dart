import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/helpers/time_helpers.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/utils/firebase_general_helpers.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';
import 'package:mared_social/widgets/items/post_share_part.dart';
import 'package:mared_social/widgets/items/review_post_options.dart';
import 'package:mared_social/widgets/items/video_post_item.dart';
import 'package:mared_social/widgets/reusable/feed_item_body_with_like.dart';
import 'package:mared_social/widgets/reusable/feed_post_item_body.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';
import 'package:mared_social/widgets/reusable/post_comments_part.dart';
import 'package:mared_social/widgets/reusable/post_item_image.dart';
import 'package:mared_social/widgets/reusable/post_likes_part.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../screens/Profile/profile.dart';

class ReviewPostItem extends StatefulWidget {
  final documentSnapshot;

  const ReviewPostItem({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _ReviewPostItemState createState() => _ReviewPostItemState();
}

class _ReviewPostItemState extends State<ReviewPostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 30.h),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.documentSnapshot['useruid'] !=
                          UserInfoManger.getUserId()) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AltProfile(
                                  userModel: UserModel(
                                      websiteLink: GeneralFirebaseHelpers
                                          .getStringSafely(
                                              key: 'websiteLink',
                                              doc: widget.documentSnapshot),
                                      bio: GeneralFirebaseHelpers
                                          .getStringSafely(
                                              key: 'bio',
                                              doc: widget.documentSnapshot),
                                      uid: widget.documentSnapshot['useruid'],
                                      userName:
                                          widget.documentSnapshot['username'],
                                      photoUrl:
                                          widget.documentSnapshot['userimage'],
                                      email:
                                          widget.documentSnapshot['useremail'],
                                      fcmToken: "",

                                      ///later you have to give this the right value
                                      store: false),
                                  userUid: widget.documentSnapshot['useruid'],
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
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.documentSnapshot['userimage'],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  LoadingWidget(constantColors: constantColors),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _postHeader(
                        userName: widget.documentSnapshot['username'],
                        address: widget.documentSnapshot['address'],
                        userId: widget.documentSnapshot['useruid']),
                  )
                ],
              ),
            ),
            FeedPostItemBody(
              imageList: widget.documentSnapshot['imageslist'],
              userId: widget.documentSnapshot['useruid'],
              postId: widget.documentSnapshot['postid'],
            ),
            SizedBox(
              height: 18.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 18.w,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.documentSnapshot['caption'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: regularTextStyle(
                        textColor: AppColors.commentButtonColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.documentSnapshot['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: lightTextStyle(
                        textColor: AppColors.commentButtonColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        TimeHelper.getElpasedTime(
                            widget.documentSnapshot['time']),
                        textAlign: TextAlign.start,
                        style: lightTextStyle(
                            textColor: AppColors.accentColor, fontSize: 11.sp),
                      ),
                    ],
                  ),
                  ReviewPostOptions(
                    acceptCallback: () async {
                      ///remove this nested structure when the popup is changed

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.documentSnapshot['useruid'])
                          .collection('posts')
                          .doc(widget.documentSnapshot['postid'])
                          .update({'approvedForPosting': true}).then((value) {
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.documentSnapshot['postid'])
                            .update({'approvedForPosting': true});
                      });
                    },
                    rejectCallback: () {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.warning,
                        confirmBtnText: "Reject",
                        cancelBtnText: "Cancel",
                        showCancelBtn: true,
                        title: "Reject this post?",
                        onConfirmBtnTap: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .deletePostData(
                                userUid: widget.documentSnapshot['useruid'],
                                postId: widget.documentSnapshot['postid'],
                              )
                              .then((value) {});
                        },
                        onCancelBtnTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _postHeader(
      {required String userName, required String address, required userId}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  if (userId != UserInfoManger.getUserId()) {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: AltProfile(
                              userModel: UserModel(
                                  websiteLink:
                                      GeneralFirebaseHelpers.getStringSafely(
                                          key: 'websiteLink',
                                          doc: widget.documentSnapshot),
                                  bio: GeneralFirebaseHelpers.getStringSafely(
                                      key: 'bio', doc: widget.documentSnapshot),
                                  uid: widget.documentSnapshot['useruid'],
                                  userName: widget.documentSnapshot['username'],
                                  photoUrl:
                                      widget.documentSnapshot['userimage'],
                                  email: widget.documentSnapshot['useremail'],
                                  fcmToken: "",

                                  ///later you have to give this the right value
                                  store: false),
                              userUid: userId,
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
                child: Text(userName,
                    style: semiBoldTextStyle(
                        fontSize: 15.sp, textColor: AppColors.accentColor))),
            SizedBox(
              height: 5.h,
            ),
            Text(
              address,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: lightTextStyle(fontSize: 11.sp, textColor: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
