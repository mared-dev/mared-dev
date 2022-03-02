import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class PostItemImage extends StatelessWidget {
  final String imageUrl;

  const PostItemImage({Key? key, required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        height: 50,
        width: 50,
        child: LoadingWidget(constantColors: constantColors),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
