import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';

class PostDetailsScreen extends StatelessWidget {
  final documentSnapshot;

  const PostDetailsScreen({Key? key, this.documentSnapshot}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: simpleAppBarWithBack(context,
          title: 'Posts',
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: FeedPostItem(
          documentSnapshot: documentSnapshot,
        ),
      ),
    );
  }
}
