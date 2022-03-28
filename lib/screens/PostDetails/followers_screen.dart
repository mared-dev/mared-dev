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
import 'package:mared_social/widgets/reusable/interacted_user_item.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FollowersScreen extends StatefulWidget {
  final followersSnap;

  const FollowersScreen({Key? key, required this.followersSnap})
      : super(key: key);

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<String> followingIds = [];
  late UserModel userInfo;

  @override
  Widget build(BuildContext context) {
    userInfo = UserInfoManger.getUserInfo();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: simpleAppBarWithBack(context,
          title: 'Followers',
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
              children: widget.followersSnap.map<Widget>((followerItem) {
                bool isUserFollowed = followingIds
                    .any((element) => element == followerItem['useruid']);
                return InteractedUserItem(
                    itemUserId: followerItem['useruid'],
                    imageUrl: followerItem['userimage'],
                    title: followerItem['username'],
                    subtitle: followerItem['useremail'],
                    trailingCallback: () async {
                      if (isUserFollowed) {
                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .unfollowUser(
                          followingUid: followerItem['useruid'],
                          followingDocId: userInfo.uid,
                          followerUid: userInfo.uid,
                          followerDocId: followerItem['useruid'],
                        );
                      } else {
                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .followUser(
                          followingUid: followerItem['useruid'],
                          followingDocId: userInfo.uid,
                          followingData: {
                            'username': userInfo.userName,
                            'userimage': userInfo.photoUrl,
                            'useremail': userInfo.email,
                            'useruid': userInfo.uid,
                            'time': Timestamp.now(),
                          },
                          followerUid: userInfo.uid,
                          followerDocId: followerItem['useruid'],
                          followerData: {
                            'username': followerItem['username'],
                            'userimage': followerItem['userimage'],
                            'useremail': followerItem['useremail'],
                            'useruid': followerItem['useruid'],
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
                      if (followerItem['useruid'] !=
                          UserInfoManger.getUserId()) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AltProfile(
                                  userModel: UserModel(
                                      uid: followerItem['useruid'],
                                      userName: followerItem['username'],
                                      photoUrl: followerItem['userimage'],
                                      email: followerItem['useremail'],
                                      fcmToken: "",

                                      ///later you have to give this the right value
                                      store: false),
                                  userUid: followerItem['useruid'],
                                ),
                                type: PageTransitionType.bottomToTop));
                      }
                    });
              }).toList());
        },
      ),
    );
  }
}
