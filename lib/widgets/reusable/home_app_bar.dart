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

PreferredSizeWidget homeAppBar(BuildContext context,
    {Widget? leadingIcon,
    Widget? actionIcon,
    Function()? leadingCallback,
    Function()? actionCallback,
    required String title}) {
  return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            if (leadingCallback != null) {
              leadingCallback();
            }
          },
          icon: leadingIcon!),
      backgroundColor: AppColors.backGroundColor,
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              if (actionCallback != null) {
                actionCallback();
              }
            },
            icon: actionIcon!),
      ],
      title: Text(
        title,
        style: semiBoldTextStyle(
            fontSize: 20, textColor: AppColors.widgetsBackground),
      ));
}
