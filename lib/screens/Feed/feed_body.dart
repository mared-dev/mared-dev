import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Feed/banners_section.dart';
import 'package:mared_social/screens/Feed/stories_section.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';

class FeedBody extends StatefulWidget {
  @override
  State<FeedBody> createState() => _FeedBodyState();
}

class _FeedBodyState extends State<FeedBody> {
  late List<Widget> _topSectionItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _topSectionItems = [StoriesSection(), BannersSection()];
  }

  @override
  Widget build(BuildContext context) {
    //temp changing StreamBuilder to FutureBuilder and .snapshot to .get
    return CustomPaginateFirestore(
      header: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _topSectionItems[index];
          },
          childCount: _topSectionItems.length,
        ),
      ),
      //item builder type is compulsory.
      itemBuilder: (context, snapshot, index) {
        dynamic documentSnapshot = snapshot[index].data()!;
        return FeedPostItem(documentSnapshot: documentSnapshot);
      },
      // orderBy is compulsory to enable pagination
      query: FirebaseFirestore.instance
          .collection("posts")
          .orderBy('time', descending: true),
      //Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
      // to fetch real-time data
      isLive: true,
    );
  }
}