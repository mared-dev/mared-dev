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
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/widgets/items/profile_post_item.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PostsProfile extends StatelessWidget {
  const PostsProfile(
      {Key? key, required this.size, this.userId, this.userModel})
      : super(key: key);

  final Size size;
  final String? userId;
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    UserModel _storedUserInfo = UserInfoManger.getUserInfo();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: userId == null ? 27.h : 0),
        children: [
          _profileHeader(userModel ?? _storedUserInfo, context),
          _userStatsSection(userModel ?? _storedUserInfo, context),
          _otherProfileSection(userModel, context),
          SizedBox(
            height: userModel == null ? 47.h : 32.h,
          ),

          ///I can only exapand to the height of my parent
          Container(
            height: 350.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(userId ?? UserInfoManger.getUserId())
                  .collection("posts")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, userPostSnap) {
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
                              userId: userId,
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
                          urls:
                              PostHelpers.checkIfPostIsVideo(item['imageslist'])
                                  ? [item['thumbnail']]
                                  : item['imageslist'],
                        ));
                  }).toList(),
                );
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
                    .doc(userId)
                    .collection("followers")
                    .doc(UserInfoManger.getUserId())
                    .snapshots(),
                builder: (context, snapshot) {
                  bool isFollowed = snapshot.data!.exists;

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
                          followingUid: userId!,
                          followingDocId: currentUserInfo.uid,
                          followingData: {
                            'username': currentUserInfo.userName,
                            'userimage': currentUserInfo.photoUrl,
                            'useremail': currentUserInfo.email,
                            'useruid': currentUserInfo.uid,
                            'time': Timestamp.now(),
                          },
                          followerUid: currentUserInfo.uid,
                          followerDocId: userId!,
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
                          followingUid: userId!,
                          followingDocId: UserInfoManger.getUserId(),
                          followerUid: UserInfoManger.getUserId(),
                          followerDocId: userId!,
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
              onPressed: () {
                print('Button Pressed');
              },
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
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userModel.uid)
                .collection("posts")
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (userModel.uid == UserInfoManger.getUserId()) {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .postSelectType(context: context);
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    radius: 70.h,
                    backgroundImage:
                        CachedNetworkImageProvider(userModel.photoUrl)),
                (userModel.uid != UserInfoManger.getUserId())
                    ? const SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          'assets/icons/add_picture_icon.svg',
                          width: 50.h,
                          height: 50.h,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              EvaIcons.email,
              color: AppColors.accentColor,
              size: 16.w,
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  userModel.email,
                  textAlign: TextAlign.center,
                  style: regularTextStyle(
                      fontSize: 10.sp, textColor: AppColors.commentButtonColor),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }
}
