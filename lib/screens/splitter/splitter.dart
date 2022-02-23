import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/auctions/auctionspage.dart';
import 'package:mared_social/screens/splitter/splitterhelper.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SplitPages extends StatefulWidget {
  @override
  _SplitPagesState createState() => _SplitPagesState();
}

class _SplitPagesState extends State<SplitPages> {
  ConstantColors constantColors = ConstantColors();
  final PageController appController = PageController();
  int pageIndex = 0;

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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              leadingWidth: 0,
              elevation: 0,
              backgroundColor: constantColors.darkColor,
              title: Provider.of<SplitPagesHelper>(context, listen: false)
                  .topNavBar(context, pageIndex, appController),
            ),
            body: PageView(
              controller: appController,
              children: [
                HomePage(),
                AuctionApp(),
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
