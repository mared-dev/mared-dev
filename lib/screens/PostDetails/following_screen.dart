import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/widgets/reusable/interacted_user_item.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Profile/profile.dart';

class FollowingScreen extends StatefulWidget {
  final followingSnap;

  const FollowingScreen({Key? key, required this.followingSnap})
      : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<String> followingIds = [];
  late UserModel userInfo;

  @override
  Widget build(BuildContext context) {
    userInfo = UserInfoManger.getUserInfo();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: simpleAppBarWithBack(context,
          title: 'Following',
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(UserInfoManger.getUserId())
            .collection("following")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            var docs = snapshot.data!.docs;
            followingIds.clear();
            for (var i = 0; i < docs.length; i++) {
              followingIds.add(docs[i]['useruid']);
            }
          }
          return ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              children: widget.followingSnap.map<Widget>((followingItem) {
                bool isUserFollowed = followingIds
                    .any((element) => element == followingItem['useruid']);
                return InteractedUserItem(
                    itemUserId: followingItem['useruid'],
                    imageUrl: followingItem['userimage'],
                    title: followingItem['username'],
                    subtitle: followingItem['useremail'],
                    shouldShowIcon:
                        followingItem['useruid'] != UserInfoManger.getUserId(),
                    trailingCallback: () async {
                      if (isUserFollowed) {
                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .unfollowUser(
                          followingUid: followingItem['useruid'],
                          followingDocId: userInfo.uid,
                          followerUid: userInfo.uid,
                          followerDocId: followingItem['useruid'],
                        );
                      } else {
                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .followUser(
                          followingUid: followingItem['useruid'],
                          followingDocId: userInfo.uid,
                          followingData: {
                            'username': userInfo.userName,
                            'userimage': userInfo.photoUrl,
                            'useremail': userInfo.email,
                            'useruid': userInfo.uid,
                            'time': Timestamp.now(),
                          },
                          followerUid: userInfo.uid,
                          followerDocId: followingItem['useruid'],
                          followerData: {
                            'username': followingItem['username'],
                            'userimage': followingItem['userimage'],
                            'useremail': followingItem['useremail'],
                            'useruid': followingItem['useruid'],
                            'time': Timestamp.now(),
                          },
                        );
                      }
                    },
                    trailingIcon: isUserFollowed
                        ? SvgPicture.asset(
                            'assets/icons/alread_followed_icon.svg')
                        : SvgPicture.asset('assets/icons/follow_icon.svg'),
                    leadingCallback: () {
                      if (followingItem['useruid'] !=
                          UserInfoManger.getUserId()) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AltProfile(
                                  userModel: UserModel(
                                      phoneNumber: GeneralFirebaseHelpers
                                          .getStringSafely(
                                              key: 'usercontactnumber',
                                              doc: followingItem),
                                      websiteLink: GeneralFirebaseHelpers
                                          .getStringSafely(
                                              key: 'websiteLink',
                                              doc: followingItem),
                                      bio: GeneralFirebaseHelpers
                                          .getStringSafely(
                                              key: 'bio', doc: followingItem),
                                      address: GeneralFirebaseHelpers
                                          .getStringSafely(
                                              key: 'address',
                                              doc: followingItem),
                                      geoPoint: GeneralFirebaseHelpers
                                          .getGeoPointSafely(
                                              key: 'geoPoint',
                                              doc: followingItem),
                                      postCategory: GeneralFirebaseHelpers
                                          .getStringSafely(
                                              key: 'postcategory',
                                              doc: followingItem),
                                      uid: followingItem['useruid'],
                                      userName: followingItem['username'],
                                      photoUrl: followingItem['userimage'],
                                      email: followingItem['useremail'],
                                      fcmToken: "",

                                      ///later you have to give this the right value
                                      store: false),
                                  userUid: followingItem['useruid'],
                                ),
                                type: PageTransitionType.rightToLeft));
                      } else {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Profile(),
                                type: PageTransitionType.rightToLeft));
                      }
                    });
              }).toList());
        },
      ),
    );
  }
}
