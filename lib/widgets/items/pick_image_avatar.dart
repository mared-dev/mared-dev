import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PickImageAvatar extends StatelessWidget {
  final File? selectedFile;
  final callback;

  PickImageAvatar(
      {Key? key, required this.callback, required this.selectedFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            radius: 51.h,
            backgroundImage: selectedFile == null
                ? const AssetImage('assets/images/empty_profile_pic.png')
                    as ImageProvider
                : FileImage(selectedFile!),
          ),
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
    );
  }
}
