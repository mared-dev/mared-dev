import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class SplitPagesHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget topNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      // bubbleCurve: Curves.bounceIn,
      // scaleCurve: Curves.decelerate,
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
        notifyListeners();
      },
      backgroundColor: constantColors.darkColor,
      items: [
        CustomNavigationBarItem(
          icon: const Icon(EvaIcons.homeOutline),
          selectedTitle: Text(
            "Mared Feed",
            style: TextStyle(
              color: constantColors.blueColor,
              fontSize: 12,
            ),
          ),
          title: Text(
            "Mared Feed",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 12,
            ),
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(FontAwesomeIcons.gavel),
          title: Text(
            "Mared Auctions",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 12,
            ),
          ),
          selectedTitle: Text(
            "Mared Auctions",
            style: TextStyle(
              color: constantColors.blueColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
