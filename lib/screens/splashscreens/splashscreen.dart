import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 3,
        ), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Provider.of<Authentication>(context, listen: false)
            .returningUserLogin(FirebaseAuth.instance.currentUser!.uid);
        Navigator.pushReplacement(context,
            PageTransition(child: SplitPages(), type: PageTransitionType.fade));
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
    return Scaffold(
      backgroundColor: constantColors.lightBlueColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: constantColors.lightBlueColor,
            height: 500,
            child: Image.asset(
              "assets/logo/animatedLogo.gif",
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
