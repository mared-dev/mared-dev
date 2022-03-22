import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';

class PostSharePart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Start HERE
        ///TODO: a feature to add later
        print('Share post!!');
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25.w,
            ),
            SvgPicture.asset('assets/icons/post_share_icon.svg'),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('share',
                  style: regularTextStyle(
                      fontSize: 11.sp,
                      textColor: AppColors.commentButtonColor)),
            ),
          ],
        ),
      ),
    );
  }
}
