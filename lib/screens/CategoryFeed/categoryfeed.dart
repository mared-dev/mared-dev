import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeedhelper.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_auto_text.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CategoryFeed extends StatelessWidget {
  final String categoryName;
  ConstantColors constantColors = ConstantColors();

  CategoryFeed({Key? key, required this.categoryName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backGroundColor,
        appBar: simpleAppBarWithAutoText(context,
            title: '$categoryName Feed',
            leadingIcon: SvgPicture.asset(
              'assets/icons/back_icon.svg',
              fit: BoxFit.fill,
              width: 22.w,
              height: 22.h,
            ), leadingCallback: () {
          Navigator.of(context).pop();
        }, minFontSize: 13, maxFontSize: 20),
        body: CustomPaginateFirestore(
          padding: EdgeInsets.only(top: 8.h, bottom: 50.h),
          //item builder type is compulsory.
          itemBuilder: (context, snapshot, index) {
            dynamic documentSnapshot = snapshot[index].data()!;
            return FeedPostItem(documentSnapshot: documentSnapshot);
          },
          // orderBy is compulsory to enable pagination
          query: FirebaseFirestore.instance
              .collection("posts")
              .where('approvedForPosting', isEqualTo: !UserInfoManger.isAdmin())
              .where('postcategory', isEqualTo: categoryName)
              .orderBy('time', descending: true),
          //Change types accordingly
          itemBuilderType: PaginateBuilderType.listView,
          // to fetch real-time data
          isLive: true,
        ));
  }
}
