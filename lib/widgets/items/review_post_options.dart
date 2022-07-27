import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';

class ReviewPostOptions extends StatelessWidget {
  final void Function() acceptCallback;
  final void Function() rejectCallback;

  const ReviewPostOptions(
      {Key? key, required this.acceptCallback, required this.rejectCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24.h,
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: acceptCallback,
            style: ElevatedButton.styleFrom(
                elevation: 3,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 7.h),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                primary: AppColors.acceptColor),
            icon: SvgPicture.asset('assets/icons/accept_post_button.svg'),
            label: Text(
              'ACCEPT',
              style: regularTextStyle(fontSize: 11, textColor: Colors.white),
            ),
          ),
          SizedBox(
            width: 30.w,
          ),
          ElevatedButton.icon(
            onPressed: rejectCallback,
            style: ElevatedButton.styleFrom(
                elevation: 3,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 7.h),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                primary: AppColors.rejectColor),
            icon: SvgPicture.asset('assets/icons/reject_post_button.svg'),
            label: Text(
              'REJECT',
              style: regularTextStyle(fontSize: 11, textColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
