import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/screens/searchPage/searchPage.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget homeAppBar(BuildContext context) {
  return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.push(
          context,
          PageTransition(
            child: SearchPage(),
            type: PageTransitionType.rightToLeft,
          ),
        ),
        icon: SvgPicture.asset(
          'assets/icons/home_search_icon.svg',
          width: 18.w,
          height: 18.h,
        ),
      ),
      backgroundColor: AppColors.backGroundColor,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            if (Provider.of<Authentication>(context, listen: false).getIsAnon ==
                false) {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            } else {
              IsAnonBottomSheet(context);
            }
          },
          icon: SvgPicture.asset(
            'assets/icons/camera_icon.svg',
            width: 20.w,
            height: 18.h,
          ),
        ),
      ],
      title: Text(
        'Mared FEED',
        style: semiBoldTextStyle(
            fontSize: 20, textColor: AppColors.widgetsBackground),
      ));
}
