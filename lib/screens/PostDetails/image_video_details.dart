import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/models/enums/post_type.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:video_player/video_player.dart';

class ImageVideoDetails extends StatelessWidget {
  final List<XFile> filesToShow;
  final PostType postType;
  final VideoPlayerController? videoPlayerController;

  const ImageVideoDetails(
      {Key? key,
      required this.filesToShow,
      required this.postType,
      this.videoPlayerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    print('-----------------');
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset(
              'assets/icons/back_icon.svg',
              color: Colors.white,
              fit: BoxFit.fill,
              width: 22.w,
              height: 22.h,
            ),
          ),
        ),
        body: Center(
          child: postType == PostType.IMAGE
              ? CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 2,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    height: 290.h,
                    enlargeCenterPage: false,
                  ),
                  items: filesToShow.map((e) {
                    return Image.file(
                      File(e.path),
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                )
              : videoPlayerController!.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        if (videoPlayerController!.value.isPlaying) {
                          videoPlayerController!.pause();
                        } else {
                          videoPlayerController!.play();
                        }
                      },
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height: videoPlayerController!.value.size.height,
                          width: videoPlayerController!.value.size.width,
                          child: VideoPlayer(
                            videoPlayerController!,
                          ),
                        ),
                      ),
                    )
                  : LoadingWidget(constantColors: constantColors),
        ));
  }
}
