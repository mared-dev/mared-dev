import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/text_styles.dart';

import 'colors.dart';

InputDecoration getAuthInputDecoration(
    {IconData? prefixIcon,
    Widget? suffixIcon,
    required String hintText,
    Color backGroundColor = AppColors.authInputFillColor,
    double verticalContentPadding = 17}) {
  return InputDecoration(
    prefixIcon: prefixIcon != null
        ? Icon(
            prefixIcon,
            color: AppColors.darkGrayTextColor,
          )
        : null,
    contentPadding: EdgeInsets.symmetric(
        vertical: verticalContentPadding.h, horizontal: 14.w),
    hintText: hintText,
    hintStyle: regularTextStyle(
        fontSize: 12.sp, textColor: AppColors.darkGrayTextColor),
    fillColor: backGroundColor,
    filled: true,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
  );
}
