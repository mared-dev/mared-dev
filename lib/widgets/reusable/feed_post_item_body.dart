import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:mared_social/widgets/items/video_post_item.dart';
import 'package:mared_social/widgets/reusable/post_item_image.dart';
import 'package:provider/provider.dart';

class FeedPostItemBody extends StatelessWidget {
  final userId;
  final postId;
  final imageList;

  const FeedPostItemBody(
      {Key? key,
      required this.userId,
      required this.postId,
      required this.imageList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, left: 15.w, right: 15.w),
      child: SizedBox(
          height: 350.h,
          width: MediaQuery.of(context).size.width,
          child: !PostHelpers.checkIfPostIsVideo(imageList)
              ? Swiper(
                  key: UniqueKey(),
                  itemBuilder: (BuildContext context, int index) {
                    // return Image.network(
                    //   imageList[index],
                    //   key: UniqueKey(),
                    //   fit: BoxFit.cover,
                    // );

                    ///legacy code
                    return PostItemImage(
                      imageUrl: imageList[index],
                    );
                  },
                  itemCount: (imageList as List).length,
                  itemHeight: 350.h,
                  itemWidth: MediaQuery.of(context).size.width,
                  layout: SwiperLayout.DEFAULT,
                  indicatorLayout: PageIndicatorLayout.SCALE,
                  pagination: SwiperPagination(
                    margin: EdgeInsets.all(10),
                    builder: DotSwiperPaginationBuilder(
                      color: constantColors.whiteColor.withOpacity(0.6),
                      activeColor: constantColors.whiteColor,
                      size: 6,
                      activeSize: 6,
                    ),
                  ),
                )
              : VideoPostItem(videoUrl: imageList[0])),
    );
  }
}
