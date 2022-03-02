import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
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
          showPostDetail(context: context, documentSnapshot: postData);
        },
        leading: SizedBox(
          height: size.height * 0.2,
          width: size.width * 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Swiper(
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
        title: Text(
          postData['caption'],
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(color: constantColors.whiteColor),
        ),
        subtitle: Text(
          postData['description'],
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: constantColors.blueColor,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
