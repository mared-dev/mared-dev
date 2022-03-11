import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:provider/provider.dart';

///move to widgets folder
Widget homePageBottomNavbar(
    BuildContext context, int index, PageController pageController) {
  UserModel _userInfo = UserInfoManger.getUserInfo();
  return CustomNavigationBar(
    currentIndex: index,
    bubbleCurve: Curves.bounceIn,
    scaleCurve: Curves.decelerate,
    selectedColor: constantColors.blueColor,
    unSelectedColor: constantColors.whiteColor,
    strokeColor: constantColors.blueColor,
    scaleFactor: 0.5,
    iconSize: 30,
    onTap: (val) {
      index = val;
      pageController.jumpToPage(
        index,
      );
    },
    backgroundColor: const Color(0xff040307),
    items: [
      CustomNavigationBarItem(icon: const Icon(EvaIcons.home)),
      CustomNavigationBarItem(icon: const Icon(EvaIcons.keypadOutline)),
      CustomNavigationBarItem(icon: const Icon(EvaIcons.messageCircle)),
      CustomNavigationBarItem(icon: const Icon(EvaIcons.mapOutline)),
      CustomNavigationBarItem(
        icon: SizedBox(
          height: 35,
          width: 35,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: _userInfo.photoUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  LoadingWidget(constantColors: constantColors),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    ],
  );
}
