import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/utils/video_thumbnail_generator.dart';

class ProfilePostItem extends StatefulWidget {
  final List<dynamic>urls;
  const ProfilePostItem({Key? key,required this.urls}) : super(key: key);

  @override
  _ProfilePostItemState createState() => _ProfilePostItemState();
}

class _ProfilePostItemState extends State<ProfilePostItem> {
  ConstantColors constantColors = ConstantColors();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: PostHelpers.checkIfPostIsVideo(widget.urls)?
             VideoThumbnailWidget(videoUrl: widget.urls[0],)
              :Swiper(
            itemBuilder:
                (BuildContext context, int index) {
              return CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.urls[index],
                progressIndicatorBuilder:
                    (context, url, downloadProgress) =>
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: LoadingWidget(
                          constantColors: constantColors),
                    ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              );
            },
            itemCount:
            widget.urls.length,
            itemHeight:
            MediaQuery.of(context).size.height * 0.3,
            itemWidth: MediaQuery.of(context).size.width,
            layout: SwiperLayout.DEFAULT,
          ),
        ),
      ),
    );
  }
}
