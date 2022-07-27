import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/colors.dart';

class LandingAuthButton extends StatelessWidget {
  final String buttonText;
  final Function() callback;

  const LandingAuthButton(
      {Key? key, required this.buttonText, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 7.h),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          primary: AppColors.widgetsBackground),
      child: Text(buttonText),
    );
  }
}
