import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/screens/PostDetails/post_details_screen.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PostResultData extends StatelessWidget {
  final postData;

  const PostResultData({Key? key, required this.postData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: () {
          pushNewScreen(
            context,
            screen: PostDetailsScreen(
              postId: postData['postid'],
              userId: postData['useruid'],
            ),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        leading: SizedBox(
          height: 80,
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Swiper(
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: postData['imageslist'][index],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingWidget(constantColors: constantColors),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
              itemCount: (postData['imageslist'] as List).length,
              itemHeight: MediaQuery.of(context).size.height * 0.3,
              itemWidth: MediaQuery.of(context).size.width,
              layout: SwiperLayout.DEFAULT,
            ),
          ),
        ),
        title: Text(postData['caption'],
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: semiBoldTextStyle(
                fontSize: 15.sp, textColor: AppColors.accentColor)),
        subtitle: Text(
          postData['description'],
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: lightTextStyle(
            textColor: AppColors.commentButtonColor,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
