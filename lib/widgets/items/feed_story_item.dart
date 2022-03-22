import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/screens/Stories/stories.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedStoryItem extends StatelessWidget {
  final int index;
  final storiesSnaps;

  const FeedStoryItem(
      {Key? key, required this.index, required this.storiesSnaps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
              child: Stories(
                querySnapshot: storiesSnaps,
                snapIndex: index,
              ),
              type: PageTransitionType.bottomToTop),
        );
      },

      ///use when listview is forcing the height/width of the chlidren
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(right: 12.w),
          width: 65,
          height: 65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.accentColor, width: 1)),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 65,
              height: 65,
              fit: BoxFit.cover,
              imageUrl: storiesSnaps.data!.docs[index]['userimage'],
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
