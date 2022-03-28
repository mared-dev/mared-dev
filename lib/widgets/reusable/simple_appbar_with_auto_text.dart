import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PreferredSizeWidget simpleAppBarWithAutoText(BuildContext context,
    {Widget? leadingIcon,
    Function()? leadingCallback,
    required String title,
    required double minFontSize,
    required double maxFontSize}) {
  return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            if (leadingCallback != null) {
              leadingCallback();
            }
          },
          icon: leadingIcon ?? Container()),
      backgroundColor: AppColors.backGroundColor,
      centerTitle: false,
      title: Container(
        alignment: Alignment.centerLeft,
        width: 0.8.sw,
        height: AppBar().preferredSize.height,
        child: AutoSizeText(
          title,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          style: const TextStyle(
              color: AppColors.commentButtonColor,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600),
        ),
      ));
}
