import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';

class SimpleButtonIcon extends StatelessWidget {
  final String buttonText;
  final Widget buttonIcon;
  final Function() buttonCallback;

  const SimpleButtonIcon(
      {Key? key,
      required this.buttonText,
      required this.buttonIcon,
      required this.buttonCallback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: buttonCallback,
        icon: buttonIcon,
        style: ElevatedButton.styleFrom(
          primary: AppColors.accentColor,
          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        label: Text(
          buttonText,
          style: regularTextStyle(
              fontSize: 11.sp, textColor: AppColors.commentButtonColor),
        ));
  }
}
