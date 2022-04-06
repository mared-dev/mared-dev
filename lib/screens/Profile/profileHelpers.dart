// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/Stories/stories_widget.dart';
import 'package:mared_social/screens/ambassaborsScreens/companiesScreen.dart';
import 'package:mared_social/screens/ambassaborsScreens/seeVideo.dart';
import 'package:mared_social/screens/auctionFeed/createAuctionScreen.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:mared_social/screens/userSettings/usersettings.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:mared_social/widgets/items/profile_post_item.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
import 'package:mared_social/widgets/reusable/bottom_sheet_top_divider.dart';
import 'package:mared_social/widgets/reusable/simple_button_icon.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();

  Widget storeProfileNavBar(
      {required BuildContext context,
      required int index,
      required PageController pageController}) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.greenColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.1,
      iconSize: 30,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(
          index,
        );
        notifyListeners();
      },
      backgroundColor: constantColors.transperant,
      items: [
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.idBadge)),

        ///this is for the auction section
        // CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.gavel)),
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.streetView)),
        CustomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.networkWired)),
      ],
    );
  }

  logOutDialog(BuildContext context) {
    return CoolAlert.show(
      context: context,
      backgroundColor: constantColors.darkColor,
      type: CoolAlertType.info,
      showCancelBtn: true,
      title: "Are you sure you want to log out?",
      confirmBtnText: "Log Out",
      onConfirmBtnTap: () async {
        await UserInfoManger.clearUserInfo();
        Provider.of<Authentication>(context, listen: false).signOutWithGoogle();
        Provider.of<Authentication>(context, listen: false)
            .logOutViaEmail()
            .whenComplete(() async {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LandingPage()),
            (Route<dynamic> route) => false,
          );
          // pushNewScreen(
          //   context,
          //   screen: LandingPage(),
          //   withNavBar: false, // OPTIONAL VALUE. True by default.
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   PageTransition(
          //     child: LandingPage(),
          //     type: PageTransitionType.topToBottom,
          //   ),
          //   (Route<dynamic> route) => false,
          // );
        });
      },
      confirmBtnTextStyle: TextStyle(
        color: constantColors.whiteColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      cancelBtnText: "No",
      cancelBtnTextStyle: TextStyle(
        color: constantColors.redColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        decoration: TextDecoration.underline,
        decorationColor: constantColors.redColor,
      ),
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }

  postSelectType({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.commentButtonColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6))),
            child: Column(
              children: [
                BottomSheetTopDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SimpleButtonIcon(
                      buttonText: "Add a post",
                      buttonIcon: SvgPicture.asset(
                        'assets/icons/add_post_icon.svg',
                        width: 14,
                        height: 14,
                      ),
                      buttonCallback: () {
                        Provider.of<UploadPost>(context, listen: false)
                            .selectPostType(context);
                      },
                    ),
                    SimpleButtonIcon(
                      buttonText: "Add a story",
                      buttonIcon: SvgPicture.asset(
                        'assets/icons/add_story_icon.svg',
                        width: 14,
                        height: 14,
                      ),
                      buttonCallback: () {
                        storyWidgets.addStory(context: context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
