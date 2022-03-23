import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';

class PostDetailsScreen extends StatefulWidget {
  final documentSnapshot;

  const PostDetailsScreen({Key? key, this.documentSnapshot}) : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  bool shouldUseSentData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shouldUseSentData = (widget.documentSnapshot != null);
  }

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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(UserInfoManger.getUserId())
              .collection("posts")
              .doc(widget.documentSnapshot['postid'])
              .snapshots(),
          builder: (context, postDocSnap) {
            if (postDocSnap.connectionState == ConnectionState.waiting ||
                !postDocSnap.hasData) {
              if (shouldUseSentData) {
                shouldUseSentData = false;
                return FeedPostItem(
                  documentSnapshot: widget.documentSnapshot,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print('!!!!!!!!!!!!!');
              print(postDocSnap.data);
              return FeedPostItem(
                documentSnapshot: postDocSnap.data,
              );
            }
          },
        ),
      ),
    );
  }
}
