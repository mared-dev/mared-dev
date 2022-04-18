import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/firebase_collections.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/Feed/banners_section.dart';
import 'package:mared_social/screens/Feed/feed_body.dart';
import 'package:mared_social/screens/Feed/stories_section.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/widgets/items/review_post_item.dart';
import 'package:mared_social/widgets/items/review_story_item.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AdminPostsFeed extends StatelessWidget {
  final String collectionName;
  final String screenTitle;

  const AdminPostsFeed(
      {Key? key, required this.collectionName, required this.screenTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //temp changing StreamBuilder to FutureBuilder and .snapshot to .get
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backGroundColor,
        appBar: homeAppBar(
          context,
          title: screenTitle,
          actionIcon: SvgPicture.asset(
            'assets/icons/logout_icon.svg',
            width: 20.w,
            height: 18.h,
          ),
          actionCallback: () {
            Provider.of<ProfileHelpers>(context, listen: false)
                .logOutDialog(context);
          },
        ),
        body: CustomPaginateFirestore(
          padding: EdgeInsets.only(top: 16.h, bottom: 32.h),
          //item builder type is compulsory.
          itemBuilder: (context, snapshot, index) {
            dynamic documentSnapshot = snapshot[index].data()!;
            return collectionName == FirebaseCollectionNames.postsCollection
                ? ReviewPostItem(documentSnapshot: documentSnapshot)
                : ReviewStoryItem(documentSnapshot: documentSnapshot);
          },
          // orderBy is compulsory to enable pagination
          query: FirebaseFirestore.instance
              .collection(collectionName)
              .where('approvedForPosting', isEqualTo: false)
              .orderBy('time', descending: true),
          //Change types accordingly
          itemBuilderType: PaginateBuilderType.listView,
          // to fetch real-time data
          isLive: true,
        ));
  }
}
