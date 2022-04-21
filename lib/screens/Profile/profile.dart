import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/screens/Profile/profile_tabs.dart';
import 'package:mared_social/screens/userSettings/usersettings.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ConstantColors constantColors = ConstantColors();
  final PageController profileController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: UserInfoManger.getAnonFlag()
          ? null
          : Container(
              margin: EdgeInsets.only(bottom: 45.h),
              child: FloatingActionButton(
                onPressed: () {
                  ProfileHelpers.postSelectType(context: context);
                },
                child:
                    SvgPicture.asset('assets/icons/home_add_post_button.svg'),
              ),
            ),
      backgroundColor: AppColors.backGroundColor,
      appBar: homeAppBar(
        context,
        title: 'MY PROFILE',
        leadingIcon: SvgPicture.asset(
          'assets/icons/back_icon.svg',
          fit: BoxFit.fill,
          width: 22.w,
          height: 22.h,
        ),
        leadingCallback: () {
          Navigator.of(context).pop();
        },
        actionIcon: SvgPicture.asset(
          'assets/icons/logout_icon.svg',
          width: 20.w,
          height: 18.h,
        ),
        actionCallback: () {
          ProfileHelpers.logOutDialog(context);
        },
      ),
      body: PostsProfile(size: size),
    );
  }
}
