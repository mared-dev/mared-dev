import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/widgets/reusable/feed_item_body_with_like.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';

class PostsSection extends StatefulWidget {
  @override
  _PostsSectionState createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  @override
  Widget build(BuildContext context) {
    //temp changing StreamBuilder to FutureBuilder and .snapshot to .get
    return CustomPaginateFirestore(
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
