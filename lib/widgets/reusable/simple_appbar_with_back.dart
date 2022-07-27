import 'package:flutter/material.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';

PreferredSizeWidget simpleAppBarWithBack(BuildContext context,
    {Widget? leadingIcon,
    Function()? leadingCallback,
    required String title,
    bool isTitleCentered = false}) {
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
      centerTitle: isTitleCentered,
      title: Text(
        title,
        style: semiBoldTextStyle(
            fontSize: 20, textColor: AppColors.widgetsBackground),
      ));
}
