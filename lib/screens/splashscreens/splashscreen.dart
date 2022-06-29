import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/authentication/update_screen.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/firestore/firestore_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/shared_preferences_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //
    // });
    Future.delayed(Duration(milliseconds: 1500)).then((value) async {
      if (FirebaseAuth.instance.currentUser != null &&
          UserInfoManger.isNotGuest()) {
        Provider.of<Authentication>(context, listen: false)
            .returningUserLogin(FirebaseAuth.instance.currentUser!.uid);
        // await Provider.of<FirebaseOperations>(context, listen: false)
        //     .initUserData(context);

        bool _shouldUpdate = await _checkIfShouldUpdate();

        if (_shouldUpdate) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: UpdateScreen(), type: PageTransitionType.fade));
        } else {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const HomePage(), type: PageTransitionType.fade));
        }
        // signed in
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.fade));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('((((((((((((((((((');
    print(SharedPreferencesHelper.getInt('anonFlag'));
    print(UserInfoManger.isNotGuest());
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: AppColors.backGroundColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/animations/mared_logo_animation_white.gif",
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  _checkIfShouldUpdate() async {
    return await FireStoreUpdate.checkIfShouldUpdate(context);
  }
}
