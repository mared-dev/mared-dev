import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/colors.dart';

class BottomSheetTopDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14.h, bottom: 16.h),
      height: 5,
      width: 135.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.darkGrayTextColor),
    );
  }
}
