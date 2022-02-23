import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class SearchPageHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget topNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      iconSize: 22,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(
          index,
        );
        notifyListeners();
      },
      backgroundColor: constantColors.transperant,
      items: [
        CustomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.users,
          ),
          title: Text(
            "Users",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 12,
            ),
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(FontAwesomeIcons.storeAlt),
          title: Text(
            "Vendors",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 12,
            ),
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(FontAwesomeIcons.instagram),
          title: Text(
            "Posts",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 12,
            ),
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(FontAwesomeIcons.gavel),
          title: Text(
            "Auctions",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
