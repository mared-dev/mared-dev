import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PickImageAvatar extends StatelessWidget {
  final callback;

  const PickImageAvatar({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: SizedBox(
        width: 102.h,
        height: 102.h,
        child: Stack(
          children: [
            Image.asset('assets/images/profile_placeholder_image.png'),
            Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/icons/add_picture_icon.svg',
                  width: 35.h,
                  height: 35.h,
                ))
          ],
        ),
      ),
    );
  }
}
