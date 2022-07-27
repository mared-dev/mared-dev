import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/text_styles.dart';

import '../../constants/colors.dart';

class SignInWithGoogleButton extends StatelessWidget {
  final String buttonText;
  final Function() callback;

  const SignInWithGoogleButton({
    Key? key,
    required this.buttonText,
    required this.callback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 36.w),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 13.5.h),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            primary: AppColors.backGroundColor),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/gmail_icon.png',
              fit: BoxFit.fill,
              width: 18,
              height: 18,
            ),
            SizedBox(
              width: 43.w,
            ),
            Text(
              buttonText,
              style: regularTextStyle(
                  fontSize: 14.sp,
                  textColor: AppColors.commentButtonColor.withOpacity(0.54)),
            ),
          ],
        ),
      ),
    );
  }
}
