import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../constants/Constantcolors.dart';
import '../../constants/colors.dart';
import '../../screens/CategoryFeed/categoryfeed.dart';

class HomeCategoryItem extends StatelessWidget {
  final categorySnapshot;

  const HomeCategoryItem({Key? key, required this.categorySnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: CategoryFeed(
            categoryName: categorySnapshot['categoryname'],
            key: Key(categorySnapshot['categoryname']),
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(right: 12.w),
          padding: EdgeInsets.all(10),
          width: 65,
          height: 65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.accentColor, width: 2)),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              imageUrl: categorySnapshot['categoryimage'],
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  LoadingWidget(constantColors: constantColors),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
