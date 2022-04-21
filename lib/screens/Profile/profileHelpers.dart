// ignore: file_names
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/Stories/stories_widget.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:mared_social/widgets/reusable/bottom_sheet_top_divider.dart';
import 'package:mared_social/widgets/reusable/simple_button_icon.dart';
import 'package:provider/provider.dart';

class ProfileHelpers {
  static final StoryWidgets storyWidgets = StoryWidgets();

  static logOutDialog(BuildContext context) {
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

  static postSelectType({required BuildContext context}) {
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
