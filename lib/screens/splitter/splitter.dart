import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/auctions/auctionspage.dart';
import 'package:mared_social/screens/splitter/splitterhelper.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SplitPages extends StatefulWidget {
  @override
  _SplitPagesState createState() => _SplitPagesState();
}

class _SplitPagesState extends State<SplitPages> {
  bool isAnon = false;

  @override
  Widget build(BuildContext context) {
    isAnon = Provider.of<Authentication>(context, listen: false).getIsAnon;
    return HomePage(isAnon: isAnon);
  }
}
