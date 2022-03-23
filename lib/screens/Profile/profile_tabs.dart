// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/screens/ambassaborsScreens/companiesScreen.dart';
import 'package:mared_social/screens/ambassaborsScreens/seeVideo.dart';
import 'package:mared_social/screens/auctionFeed/createAuctionScreen.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:mared_social/screens/userSettings/usersettings.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/widgets/items/profile_post_item.dart';
import 'package:mared_social/widgets/items/promoted_post_item.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostsProfile extends StatelessWidget {
  const PostsProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    UserModel _userInfo = UserInfoManger.getUserInfo();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 27.h),
        children: [
          _profileHeader(_userInfo, context),
          _userStatsSection(_userInfo, context),
          SizedBox(
            height: 47.h,
          ),

          ///I can only exapand to the height of my parent
          Container(
            height: 350.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserId)
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
                          showPostDetail(
                              context: context, documentSnapshot: item);
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
        InkWell(
          onTap: () {
            Provider.of<ProfileHelpers>(context, listen: false)
                .checkFollowerSheet(context: context, userId: userModel.uid);
          },
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(userModel.uid)
                  .collection("followers")
                  .snapshots(),
              builder: (context, followerSnap) {
                if (followerSnap.hasData) {
                  return _statItem(
                      statText: 'Followers',
                      statValue: followerSnap.data!.docs.length.toString());
                }
                return _statItem(statText: 'Followers', statValue: '0');
              }),
        ),
        SizedBox(
          width: 23.w,
        ),
        InkWell(
          onTap: () {
            Provider.of<ProfileHelpers>(context, listen: false)
                .checkFollowingSheet(context: context, userId: userModel.uid);
          },
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(userModel.uid)
                  .collection("following")
                  .snapshots(),
              builder: (context, followingSnap) {
                if (followingSnap.hasData) {
                  return _statItem(
                    statText: 'Following',
                    statValue: followingSnap.data!.docs.length.toString(),
                  );
                }
                return _statItem(statText: 'Following', statValue: "0");
              }),
        ),
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
            Provider.of<ProfileHelpers>(context, listen: false)
                .postSelectType(context: context);
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
                Positioned(
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
