import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/PostDetails/likes_screen.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PostLikesPart extends StatelessWidget {
  final postId;
  final likes;
  final userId;

  const PostLikesPart(
      {Key? key,
      required this.postId,
      required this.likes,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Provider.of<PostFunctions>(context, listen: false).addLike(
                userUid: userId,
                context: context,
                postID: postId,
                subDocId: UserInfoManger.getUserId(),
              );
            },
            child: SvgPicture.asset(
              likes.any((element) =>
                      element['useruid'] == UserInfoManger.getUserId())
                  ? 'assets/icons/post_like_filled_icon.svg'
                  : 'assets/icons/post_like_comment.svg',
              width: 20,
              height: 18,
            ),
          ),
          InkWell(
            onTap: () {
              pushNewScreen(
                context,
                screen: LikesScreen(
                  likes: likes,
                ),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: 8.w, top: 10.h, bottom: 10.h),
              child: Text('likes'.tr(),
                  style: regularTextStyle(
                      fontSize: 11, textColor: AppColors.likeFilledColor)),
            ),
          ),
        ],
      ),
    );
  }
}
