import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:provider/provider.dart';

class PostLikesPart extends StatelessWidget {
  final postId;
  final likes;

  const PostLikesPart({Key? key, required this.postId, required this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<PostFunctions>(context, listen: false)
            .showLikes(context: context, likes: likes);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              likes.any((element) =>
                      element['useruid'] ==
                      Provider.of<Authentication>(context, listen: false)
                          .getUserId)
                  ? 'assets/icons/post_like_filled_icon.svg'
                  : 'assets/icons/post_like_comment.svg',
              width: 20,
              height: 18,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text('like',
                  style: regularTextStyle(
                      fontSize: 11, textColor: AppColors.likeFilledColor)),
            ),
          ],
        ),
      ),
    );
  }
}
