import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class ProfileVideoItemThumb extends StatelessWidget {
  final String thumbnailUrl;

  const ProfileVideoItemThumb({Key? key, required this.thumbnailUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: thumbnailUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
              child: LoadingWidget(constantColors: constantColors),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Center(
          child: SvgPicture.asset(
            'assets/icons/profile_video_thumb.svg',
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
