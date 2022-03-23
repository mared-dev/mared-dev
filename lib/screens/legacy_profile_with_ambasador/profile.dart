import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/legacy_profile_with_ambasador/profileHelpers.dart';
import 'package:mared_social/screens/legacy_profile_with_ambasador/profile_tabs.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';

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
      bottomNavigationBar: Container(
          height: size.height * 0.075,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
          ),
          child: UserInfoManger.getUserInfo().store
              ? Provider.of<ProfileHelpers>(context, listen: false)
                  .profileNavBar(
                      context: context,
                      index: pageIndex,
                      pageController: profileController)
              : Provider.of<ProfileHelpers>(context, listen: false)
                  .storeProfileNavBar(
                      context: context,
                      index: pageIndex,
                      pageController: profileController)),
      body: PageView(
        controller: profileController,
        children: [
          PostsProfile(constantColors: constantColors, size: size),

          ///currently commented
          // AuctionsProfile(constantColors: constantColors, size: size),
          AmbassadorProfile(constantColors: constantColors, size: size),
          UserSubmittedWorkProfile(constantColors: constantColors, size: size),
        ],
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            pageIndex = value;
          });
        },
      ),
    );
  }
}
