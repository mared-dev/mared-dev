import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/text_styles.dart';

import '../../constants/colors.dart';

class SignInWithAppleButton extends StatelessWidget {
  final String buttonText;
  final Function() callback;

  const SignInWithAppleButton({
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
            side: BorderSide(width: 1, color: Colors.black),
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.h),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            primary: AppColors.backGroundColor),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/apple_icon.svg',
              fit: BoxFit.fill,
              width: 18,
              height: 23,
            ),
            SizedBox(
              width: 43.w,
            ),
            Text(
              buttonText,
              style: semiBoldTextStyle(
                  fontSize: 14.sp, textColor: AppColors.commentButtonColor),
            ),
          ],
        ),
      ),
    );
  }
}
