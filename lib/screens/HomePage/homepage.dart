import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Categories/category.dart';
import 'package:mared_social/screens/Chatroom/chatroom.dart';
import 'package:mared_social/screens/Feed/feed.dart';
import 'package:mared_social/screens/HomePage/homepageHelpers.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/Profile/profile.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/screens/mapscreen/mapscreen.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final bool isAnon;
  const HomePage({
    required this.isAnon,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  int pageIndex = 0;
  bool loading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await load();
      // await Provider.of<FirebaseOperations>(context, listen: false)
      //     .initUserData(context);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
    super.initState();
  }

  Future<void> load() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top]);
    }

    _fcm.getAPNSToken().then((value) => print("APN Token === $value"));

    String? token = await _fcm.getToken();
    assert(token != null);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .update({
      'fcmToken': token,
    });
  }

  // final _screens = [
  //   Feed(),
  //   CategoryScreen(),
  //   Provider.of<Authentication>(context, listen: false).getIsAnon == false
  //       ? Chatroom()
  //       : IsAnonMsg(),
  //   MapScreen(),
  //   Provider.of<Authentication>(context, listen: false).getIsAnon == false
  //       ? Profile()
  //       : IsAnonMsg(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homepageController,
        children: [
          Feed(),
          CategoryScreen(),
          Provider.of<Authentication>(context, listen: false).getIsAnon == false
              ? Chatroom()
              : IsAnonMsg(),
          MapScreen(),
          Provider.of<Authentication>(context, listen: false).getIsAnon == false
              ? Profile()
              : IsAnonMsg(),
        ],
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar:
          homePageBottomNavbar(context, pageIndex, homepageController),
    );
  }
}
