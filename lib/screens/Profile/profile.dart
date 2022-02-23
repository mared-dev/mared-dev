import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';

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
          child:
              Provider.of<FirebaseOperations>(context, listen: false).store ==
                      false
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
          AuctionsProfile(constantColors: constantColors, size: size),
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
