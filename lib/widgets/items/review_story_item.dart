import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class ReviewStoryItem extends StatefulWidget {
  final documentSnapshot;

  const ReviewStoryItem({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _ReviewStoryItemState createState() => _ReviewStoryItemState();
}

class _ReviewStoryItemState extends State<ReviewStoryItem> {
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
                                        phoneNumber: GeneralFirebaseHelpers
                                            .getStringSafely(
                                                key: 'usercontactnumber',
                                                doc: widget.documentSnapshot),
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
                                        photoUrl: widget
                                            .documentSnapshot['userimage'],
                                        email: widget
                                            .documentSnapshot['useremail'],
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
                            progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
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
                          address: widget.documentSnapshot['useremail'],
                          userId: widget.documentSnapshot['useruid']),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  height: 0.6.sh,
                  child: VideoPostItem(
                      userId: widget.documentSnapshot['useruid'],
                      videoThumbnailLink: widget.documentSnapshot['thumbnail'],
                      videoUrl: widget.documentSnapshot['videourl'])),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: ReviewPostOptions(
                  acceptCallback: () {
                    FirebaseFirestore.instance
                        .collection('stories')
                        .doc(widget.documentSnapshot['storyid'])
                        .update({'approvedForPosting': true});
                  },
                  rejectCallback: () {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.warning,
                      title: "Reject Story?",
                      text: "Are you sure you want to reject this story?",
                      showCancelBtn: true,
                      cancelBtnText: "No",
                      confirmBtnText: "Yes",
                      onCancelBtnTap: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      onConfirmBtnTap: () async {
                        try {
                          Navigator.of(context, rootNavigator: true).pop();
                          FirebaseFirestore.instance
                              .collection("stories")
                              .doc(widget.documentSnapshot['storyid'])
                              .delete()
                              .whenComplete(() async {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.documentSnapshot['useruid'])
                                .collection("stories")
                                .doc(widget.documentSnapshot['storyid'])
                                .delete()
                                .whenComplete(() {});
                          });
                        } catch (e) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: "Operation Failed",
                            text: e.toString(),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
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
                                  phoneNumber:
                                      GeneralFirebaseHelpers.getStringSafely(
                                          key: 'usercontactnumber',
                                          doc: widget.documentSnapshot),
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
