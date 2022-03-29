import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/text_styles.dart';

class SearchPageHeaderTabs extends StatefulWidget {
  final PageController pageController;

  const SearchPageHeaderTabs({Key? key, required this.pageController})
      : super(key: key);
  @override
  _SearchPageHeaderTabsState createState() => _SearchPageHeaderTabsState();
}

class _SearchPageHeaderTabsState extends State<SearchPageHeaderTabs> {
  List itemsToShow = [];
  int currentlySelectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemsToShow = [
      {'label': 'USERS', 'imagePath': 'assets/icons/user_result_icon.svg'},
      {'label': 'VENDORS', 'imagePath': 'assets/icons/verndor_result_icon.svg'},
      {'label': 'POSTS', 'imagePath': 'assets/icons/post_result_icon.svg'},
    ];
    currentlySelectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              itemsToShow.length,
              (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print(index);
                        setState(() {
                          currentlySelectedIndex = index;
                        });
                        widget.pageController.jumpToPage(
                          currentlySelectedIndex,
                        );
                      },
                      child: _optionItem(
                          imagePath: itemsToShow[index]['imagePath'],
                          label: itemsToShow[index]['label'],
                          isLastItem: index == itemsToShow.length - 1,
                          index: index),
                    ),
                  ))),
    );
  }

  Widget _optionItem(
      {required String imagePath,
      required String label,
      required bool isLastItem,
      required int index}) {
    return Container(
      padding: EdgeInsets.only(left: 13.w, right: isLastItem ? 0 : 13.w),
      decoration: BoxDecoration(
        border: isLastItem
            ? null
            : Border(
                right:
                    BorderSide(width: 2, color: AppColors.commentButtonColor)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            imagePath,
            width: 18,
            height: 18,
            color: index == currentlySelectedIndex
                ? AppColors.accentColor
                : AppColors.commentButtonColor,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              child: AutoSizeText(
            label,
            style: semiBoldTextStyle(
                fontSize: 13,
                textColor: index == currentlySelectedIndex
                    ? AppColors.accentColor
                    : AppColors.commentButtonColor),
            maxLines: 1,
            minFontSize: 10,
            maxFontSize: 13,
          )),
        ],
      ),
    );
  }
}

//
// class SearchPage {
//   ConstantColors constantColors = ConstantColors();
//   static Widget topNavBar(
//       BuildContext context, int index, PageController pageController) {
//
//
//     return CustomNavigationBar(
//       currentIndex: index,
//       selectedColor: AppColors.accentColor,
//       unSelectedColor: AppColors.commentButtonColor,
//       onTap: (val) {
//         index = val;
//         pageController.jumpToPage(
//           index,
//         );
//       },
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       items: [
//         CustomNavigationBarItem(
//           icon: Icon(
//             FontAwesomeIcons.users,
//           ),
//           title: Text(
//             "Users",
//             style: TextStyle(
//               color: AppColors.commentButtonColor,
//               fontSize: 12,
//             ),
//           ),
//         ),
//         CustomNavigationBarItem(
//           icon: const Icon(FontAwesomeIcons.storeAlt),
//           title: Text(
//             "Vendors",
//             style: TextStyle(
//               color: AppColors.commentButtonColor,
//               fontSize: 12,
//             ),
//           ),
//         ),
//         CustomNavigationBarItem(
//           icon: const Icon(FontAwesomeIcons.instagram),
//           title: Text(
//             "Posts",
//             style: TextStyle(
//               color: AppColors.commentButtonColor,
//               fontSize: 12,
//             ),
//           ),
//         ),
//         // CustomNavigationBarItem(
//         //   icon: const Icon(FontAwesomeIcons.gavel),
//         //   title: Text(
//         //     "Auctions",
//         //     style: TextStyle(
//         //       color: AppColors.commentButtonColor,
//         //       fontSize: 12,
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
//
//
// }
