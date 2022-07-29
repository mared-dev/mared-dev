import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/config.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/mangers/posts_refresh_manger.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/Feed/banners_section.dart';
import 'package:mared_social/screens/Feed/stories_section.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/widgets/items/home_categories_section.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/feed_post_item_body.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';

class FeedBody extends StatefulWidget {
  @override
  State<FeedBody> createState() => _FeedBodyState();
}

class _FeedBodyState extends State<FeedBody> {
  late List<Widget> _topSectionItems;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _topSectionItems = [
      HomeCategoriesSection(),

      // BannersSection(),
    ];
  }

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    //temp changing StreamBuilder to FutureBuilder and .snapshot to .get
    return CustomPaginateFirestore(
      ///TODO:uncomment for stories feature
      header: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _topSectionItems[index];
          },
          childCount: _topSectionItems.length,
        ),
      ),
      // header: SliverPadding(
      //   padding: EdgeInsets.only(top: 24.h),
      // ),
      //item builder type is compulsory.
      itemBuilder: (context, snapshot, index) {
        dynamic documentSnapshot = snapshot[index].data()!;
        return FeedPostItem(
          documentSnapshot: documentSnapshot,
          isInPostDetails: false,
        );
      },
      onEmpty: Column(
        children: [
          // _topSectionItems[0],
          ///TODO:uncomment for stories feature
          // _topSectionItems[1],
          Expanded(
            child: Center(
              child: Text(
                'no_posts_to_show'.tr(),
                style: regularTextStyle(
                    fontSize: 14, textColor: AppColors.commentButtonColor),
              ),
            ),
          )
        ],
      ),

      // orderBy is compulsory to enable pagination
      query: FirebaseFirestore.instance
          .collection("posts")
          .where('approvedForPosting', isEqualTo: true)
          .orderBy('time', descending: true),

      //Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
      // to fetch real-time data
      isLive: false,
      itemsPerPage: 19,
      listeners: [getIt.get<PaginateRefreshedChangeListener>()],
    );
  }
}
