import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/Profile/profile_tabs.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';

class AltProfile extends StatelessWidget {
  final String userUid;
  final UserModel userModel;
  AltProfile({Key? key, required this.userUid, required this.userModel})
      : super(key: key);

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: simpleAppBarWithBack(context,
          title: '',
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: PostsProfile(
        userModel: userModel,
        userId: userUid,
        size: size,
      ),
    );
  }
}
