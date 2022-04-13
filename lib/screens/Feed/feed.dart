import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/screens/Feed/feed_body.dart';
import 'package:mared_social/screens/Profile/profile.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/screens/searchPage/searchPage.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../mangers/user_info_manger.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('(((((((((((((((((');
    print(UserInfoManger.getUserInfo().email);
    print(UserInfoManger.getUserInfo().userName);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backGroundColor,
      appBar: homeAppBar(
        context,
        title: 'Mared FEED',
        leadingIcon: SvgPicture.asset(
          'assets/icons/home_search_icon.svg',
          width: 18.w,
          height: 18.h,
        ),
        leadingCallback: () {
          pushNewScreen(
            context,
            screen: SearchPage(),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        actionIcon: SvgPicture.asset(
          'assets/icons/user_result_icon.svg',
          color: AppColors.commentButtonColor,
          width: 21.w,
          height: 21.h,
        ),
        actionCallback: () {
          if (Provider.of<Authentication>(context, listen: false).getIsAnon ==
              false) {
            pushNewScreen(
              context,
              screen: Profile(),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          } else {
            IsAnonBottomSheet(context);
          }
        },
      ),
      body: FeedBody(),
    );
  }
}
