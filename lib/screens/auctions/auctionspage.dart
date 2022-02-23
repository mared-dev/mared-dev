import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/Profile/profile.dart';
import 'package:mared_social/screens/auctionFeed/auctionFeed.dart';
import 'package:mared_social/screens/auctionMap/auctionMapScreen.dart';
import 'package:mared_social/screens/auctions/auctionPageHelper.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/screens/myBids/myBids.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AuctionApp extends StatefulWidget {
  const AuctionApp({Key? key}) : super(key: key);

  @override
  State<AuctionApp> createState() => _AuctionAppState();
}

class _AuctionAppState extends State<AuctionApp> {
  final PageController auctionAppController = PageController();
  int pageIndex = 0;
  ConstantColors constantColors = ConstantColors();

  bool bigError = false;

  Future checkUserDoc() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (!value.exists) {
        setState(() {
          bigError = true;
        });
      } else {
        setState(() {
          bigError = false;
        });
      }
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await checkUserDoc();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bigError == false
        ? Scaffold(
            bottomNavigationBar:
                Provider.of<AuctionAppHelper>(context, listen: false)
                    .bottomNavBar(context, pageIndex, auctionAppController),
            body: PageView(
              controller: auctionAppController,
              children: [
                AuctionFeed(),
                AuctionMap(),
                MyBids(),
                Provider.of<Authentication>(context, listen: false).getIsAnon ==
                        false
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
          )
        : Scaffold(
            backgroundColor: constantColors.darkColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Oops, looks like there was an error authenticating you.\nPlease Log out and login again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: constantColors.whiteColor, fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<Authentication>(context, listen: false)
                                .signOutWithGoogle();
                            Provider.of<Authentication>(context, listen: false)
                                .logOutViaEmail()
                                .whenComplete(() {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: LandingPage(),
                                    type: PageTransitionType.topToBottom),
                              );
                            });
                          },
                          icon: Icon(FontAwesomeIcons.signInAlt),
                          label: Text("Logout")),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
