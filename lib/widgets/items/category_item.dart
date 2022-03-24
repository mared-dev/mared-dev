import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/color_helpers.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeed.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeedhelper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final catDocSnap;

  const CategoryItem({Key? key, this.catDocSnap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // * Push to Category screen
        await Provider.of<CatgeoryFeedHelper>(context, listen: false)
            .getCategoryNameVal(categoryNameVal: catDocSnap['categoryname']);

        pushNewScreen(
          context,
          screen: CategoryFeed(
            categoryName: catDocSnap['categoryname'],
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );

        // Navigator.push(
        //     context,
        //     PageTransition(
        //         child: CategoryFeed(
        //           categoryName: catDocSnap['categoryname'],
        //         ),
        //         type: PageTransitionType.rightToLeft));
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 17.h),
            decoration: BoxDecoration(
              color: ColorHelpers.convertHexStringToColor(catDocSnap['color']),
              borderRadius: BorderRadius.circular(90),
            ),
            child: Center(
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: catDocSnap['categoryimage'],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Text(
            catDocSnap['categoryname'],
            maxLines: 2,
            textAlign: TextAlign.center,
            style: semiBoldTextStyle(
              fontSize: 11,
              textColor: AppColors.commentButtonColor,
            ),
          )
        ],
      ),
      // child: Column(
      //   children: [
      //     Container(
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color:
      //               ColorHelpers.convertHexStringToColor(catDocSnap['color']),
      //           border: Border.all(
      //             color: constantColors.blueColor,
      //             width: 3,
      //           ),
      //           borderRadius: BorderRadius.circular(30),
      //         ),
      //         height: 80,
      //         width: 80,
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(100),
      //           child: CachedNetworkImage(
      //             fit: BoxFit.cover,
      //             imageUrl: catDocSnap['categoryimage'],
      //             progressIndicatorBuilder: (context, url, downloadProgress) =>
      //                 LoadingWidget(constantColors: constantColors),
      //             errorWidget: (context, url, error) => const Icon(Icons.error),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Text(
      //       catDocSnap['categoryname'],
      //       style: TextStyle(
      //         color: constantColors.whiteColor,
      //         fontWeight: FontWeight.bold,
      //         fontSize: 10,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
