import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/widgets/items/home_category_item.dart';

import '../../constants/colors.dart';
import '../../mangers/user_info_manger.dart';
import 'feed_story_item.dart';

class HomeCategoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      // margin: EdgeInsets.only(top: 27, bottom: 20),
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("category").snapshots(),
        builder: (context, storiesSnaps) {
          if (storiesSnaps.hasData && storiesSnaps.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Stories Yet",
                style: TextStyle(
                  color: AppColors.backGroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            );
          } else if (storiesSnaps.hasData && storiesSnaps.data != null) {
            return ListView.builder(
              itemCount: storiesSnaps.data!.docs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return HomeCategoryItem(
                    categorySnapshot: storiesSnaps.data!.docs[index]);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
