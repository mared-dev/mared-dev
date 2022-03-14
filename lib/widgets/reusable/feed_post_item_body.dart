import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        onDoubleTap: () {
          if (Provider.of<Authentication>(context, listen: false).getIsAnon ==
              false) {
            Provider.of<PostFunctions>(context, listen: false).addLike(
              userUid: userId,
              context: context,
              postID: postId,
              subDocId:
                  Provider.of<Authentication>(context, listen: false).getUserId,
            );
          } else {
            IsAnonBottomSheet(context);
          }
        },
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.44,
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
                    itemHeight: MediaQuery.of(context).size.height * 0.3,
                    itemWidth: MediaQuery.of(context).size.width,
                    layout: SwiperLayout.DEFAULT,
                    indicatorLayout: PageIndicatorLayout.SCALE,
                    pagination: SwiperPagination(
                      margin: EdgeInsets.all(10),
                      builder: DotSwiperPaginationBuilder(
                        color: constantColors.whiteColor.withOpacity(0.6),
                        activeColor: constantColors.darkColor.withOpacity(0.6),
                        size: 15,
                        activeSize: 15,
                      ),
                    ),
                  )
                : VideoPostItem(videoUrl: imageList[0])),
      ),
    );
  }
}
