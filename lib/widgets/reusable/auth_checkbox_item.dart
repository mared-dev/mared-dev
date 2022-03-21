import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';

class AuthCheckboxItem extends StatelessWidget {
  final bool isSelected;
  final String optionText;

  const AuthCheckboxItem(
      {Key? key, required this.isSelected, required this.optionText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 21.h, bottom: 28.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isSelected
                ? 'assets/icons/checked_box.svg'
                : 'assets/icons/unchecked_box.svg',
            width: 12.h,
            height: 12.h,
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: 7.w,
          ),
          Text(
            optionText,
            style: regularTextStyle(
                fontSize: 12, textColor: AppColors.darkGrayTextColor),
          ),
          SizedBox(
            width: 26.w,
          ),
        ],
      ),
    );
  }
}
