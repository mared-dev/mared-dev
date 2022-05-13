// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/PostDetails/followers_screen.dart';
import 'package:mared_social/screens/PostDetails/following_screen.dart';
import 'package:mared_social/screens/PostDetails/post_details_screen.dart';
import 'package:mared_social/screens/Profile/edit_profile_screen.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/utils/url_launcher_utils.dart';
import 'package:mared_social/widgets/bottom_sheets/confirm_post_image_video.dart';
import 'package:mared_social/widgets/items/profile_post_item.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PostsProfile extends StatefulWidget {
  const PostsProfile(
      {Key? key, required this.size, this.userId, this.userModel})
      : super(key: key);

  final Size size;
  final String? userId;
  final UserModel? userModel;

  @override
  State<PostsProfile> createState() => _PostsProfileState();
}

class _PostsProfileState extends State<PostsProfile> {
  @override
  Widget build(BuildContext context) {
    UserModel _storedUserInfo = UserInfoManger.getUserInfo();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: widget.userId == null ? 27.h : 0),
        children: [
          _profileHeader(widget.userModel ?? _storedUserInfo, context),
          _userStatsSection(widget.userModel ?? _storedUserInfo, context),
          _otherProfileSection(widget.userModel, context),
          SizedBox(
            height: widget.userModel == null ? 47.h : 32.h,
          ),

          ///I can only exapand to the height of my parent
          Container(
            height: 350.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.userId ?? UserInfoManger.getUserId())
                  .collection("posts")
                  .where('approvedForPosting', isEqualTo: true)
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, userPostSnap) {
                if (userPostSnap.hasData && !userPostSnap.hasError) {
                  return GridView.count(
                    padding: EdgeInsets.only(bottom: 60.h),
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    children: userPostSnap.data!.docs.map<Widget>((item) {
                      return InkWell(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: PostDetailsScreen(
                                userId: widget.userId,
                                postId: item['postid'],
                                documentSnapshot: item,
                              ),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: ProfilePostItem(
                            isVideo: PostHelpers.checkIfPostIsVideo(
                                item['imageslist']),
                            urls: PostHelpers.checkIfPostIsVideo(
                                    item['imageslist'])
                                ? [item['thumbnail']]
                                : item['imageslist'],
                          ));
                    }).toList(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherProfileSection(UserModel? userModel, BuildContext context) {
    if (userModel == null) {
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 19.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.userId)
                    .collection("followers")
                    .doc(UserInfoManger.getUserId())
                    .snapshots(),
                builder: (context, snapshot) {
                  bool isFollowed =
                      snapshot.hasData ? snapshot.data!.exists : false;

                  return ElevatedButton.icon(
                    icon: SvgPicture.asset(
                      isFollowed
                          ? 'assets/icons/alread_followed_icon.svg'
                          : 'assets/icons/follow_icon.svg',
                      color: isFollowed
                          ? Colors.white
                          : AppColors.commentButtonColor,
                    ),
                    label: Text(
                      isFollowed ? 'unfollow' : 'follow',
                      style: regularTextStyle(
                          fontSize: 11,
                          textColor: isFollowed
                              ? Colors.white
                              : AppColors.commentButtonColor),
                    ),
                    onPressed: () {
                      if (!isFollowed) {
                        UserModel currentUserInfo =
                            UserInfoManger.getUserInfo();
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .followUser(
                          followingUid: widget.userId!,
                          followingDocId: currentUserInfo.uid,
                          followingData: {
                            'username': currentUserInfo.userName,
                            'userimage': currentUserInfo.photoUrl,
                            'useremail': currentUserInfo.email,
                            'useruid': currentUserInfo.uid,
                            'time': Timestamp.now(),
                          },
                          followerUid: currentUserInfo.uid,
                          followerDocId: widget.userId!,
                          followerData: {
                            'username': userModel.userName,
                            'userimage': userModel.photoUrl,
                            'useremail': userModel.email,
                            'useruid': userModel.uid,
                            'time': Timestamp.now(),
                          },
                        );
                      } else {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .unfollowUser(
                          followingUid: widget.userId!,
                          followingDocId: UserInfoManger.getUserId(),
                          followerUid: UserInfoManger.getUserId(),
                          followerDocId: widget.userId!,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 7.h, horizontal: 20.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  );
                }),
            ElevatedButton.icon(
              icon: SvgPicture.asset(
                'assets/icons/message_user_icon.svg',
                color: AppColors.commentButtonColor,
              ),
              label: Text(
                'message',
                style: regularTextStyle(
                    fontSize: 11, textColor: AppColors.commentButtonColor),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _userStatsSection(UserModel userModel, BuildContext context) {
    print(userModel.uid);
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userModel.uid)
                .collection("posts")
                .where('approvedForPosting',
                    isEqualTo: !UserInfoManger.isAdmin())
                .snapshots(),
            builder: (context, userPostSnaps) {
              if (!userPostSnaps.hasData) {
                return _statItem(statText: 'Posts', statValue: '0');
              } else {
                return _statItem(
                  statText: 'Posts',
                  statValue: userPostSnaps.data!.docs.length.toString(),
                );
              }
            }),
        SizedBox(
          width: 23.w,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userModel.uid)
                .collection("followers")
                .snapshots(),
            builder: (context, followerSnap) {
              return InkWell(
                  onTap: () {
                    if (followerSnap.hasData) {
                      // Provider.of<ProfileHelpers>(context, listen: false)
                      //     .checkFollowerSheet(
                      //         context: context, userId: userModel.uid);

                      pushNewScreen(
                        context,
                        screen: FollowersScreen(
                          followersSnap: followerSnap.data!.docs,
                        ),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    }
                  },
                  child: _statItem(
                      statText: 'Followers',
                      statValue: followerSnap.hasData
                          ? followerSnap.data!.docs.length.toString()
                          : "0"));
            }),
        SizedBox(
          width: 23.w,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userModel.uid)
                .collection("following")
                .snapshots(),
            builder: (context, followingSnap) {
              return InkWell(
                child: _statItem(
                  statText: 'Following',
                  statValue: followingSnap.hasData
                      ? followingSnap.data!.docs.length.toString()
                      : "0",
                ),
                onTap: () {
                  // Provider.of<ProfileHelpers>(context, listen: false)
                  //     .checkFollowingSheet(context: context, userId: userModel.uid);

                  if (followingSnap.hasData) {
                    pushNewScreen(
                      context,
                      screen: FollowingScreen(
                          followingSnap: followingSnap.data!.docs),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  }
                },
              );
            }),
      ],
    );
  }

  Widget _statItem({required String statText, required String statValue}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          statValue,
          style:
              lightTextStyle(fontSize: 20.sp, textColor: AppColors.accentColor),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          statText,
          style: lightTextStyle(
              fontSize: 12.sp, textColor: AppColors.commentButtonColor),
        )
      ],
    );
  }

  Widget _profileHeader(UserModel userModel, BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId ?? UserInfoManger.getUserId())
          .collection("extrainfo")
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
              extraInfoSnapshot) {
        String bio = "", websiteLink = "", imageUrl = "";

        if (extraInfoSnapshot.hasData &&
            extraInfoSnapshot.data!.docs.isNotEmpty) {
          bio = extraInfoSnapshot.data!.docs[0]['bio'];
          websiteLink = extraInfoSnapshot.data!.docs[0]['websiteLink'];
          imageUrl = extraInfoSnapshot.data!.docs[0]['userimage'];
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (userModel.uid == UserInfoManger.getUserId()) {
                  userModel = UserInfoManger.getUserInfo();
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                                userModel: userModel,
                              )))
                      .then((value) {
                    setState(() {});
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        radius: 65.h,
                        backgroundImage: CachedNetworkImageProvider(
                            imageUrl.isNotEmpty
                                ? imageUrl
                                : userModel.photoUrl)),
                    (userModel.uid != UserInfoManger.getUserId())
                        ? const SizedBox(
                            width: 0,
                            height: 0,
                          )
                        : Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: AppColors.accentColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 22.h,
                              ),
                            ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 13.h,
            ),
            Text(
              userModel.userName,
              textAlign: TextAlign.center,
              style: semiBoldTextStyle(
                  fontSize: 17.sp, textColor: AppColors.accentColor),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              bio.isNotEmpty ? bio : userModel.bio,
              textAlign: TextAlign.center,
              style: regularTextStyle(
                  fontSize: 9.sp, textColor: AppColors.commentButtonColor),
            ),
            if (userModel.bio.isNotEmpty)
              SizedBox(
                height: 12.h,
              ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 10,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      EvaIcons.email,
                      color: AppColors.accentColor,
                      size: 16.w,
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          userModel.email,
                          textAlign: TextAlign.center,
                          style: semiBoldTextStyle(
                              fontSize: 10.sp,
                              textColor: AppColors.commentButtonColor),
                        ),
                      ),
                    ),
                  ],
                ),
                if (userModel.websiteLink.isNotEmpty)
                  InkWell(
                    onTap: () {
                      UrlLauncherUtils.openWebsite(userModel.websiteLink);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          EvaIcons.globe,
                          color: AppColors.accentColor,
                          size: 16.w,
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              'Website',
                              textAlign: TextAlign.center,
                              style: semiBoldTextStyle(
                                  fontSize: 10.sp,
                                  textColor: AppColors.commentButtonColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
          ],
        );
      },
    );
  }
}
