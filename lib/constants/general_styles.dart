import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/text_styles.dart';

import 'colors.dart';

InputDecoration getAuthInputDecoration({
  IconData? prefixIcon,
  required String hintText,
}) {
  return InputDecoration(
    prefixIcon: prefixIcon != null
        ? Icon(
            prefixIcon,
            color: AppColors.darkGrayTextColor,
          )
        : null,
    contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 14.w),
    hintText: hintText,
    hintStyle: regularTextStyle(
        fontSize: 12.sp, textColor: AppColors.darkGrayTextColor),
    fillColor: AppColors.authInputFillColor,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
  );
}
