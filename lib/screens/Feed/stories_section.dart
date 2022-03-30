import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/widgets/items/feed_story_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoriesSection extends StatefulWidget {
  @override
  _StoriesSectionState createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      // margin: EdgeInsets.only(top: 27, bottom: 20),
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("stories")
            .orderBy('time', descending: true)
            .snapshots(),
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
                return FeedStoryItem(
                  index: index,
                  storiesSnaps: storiesSnaps,
                );
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
