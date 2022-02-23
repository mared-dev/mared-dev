import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/SearchFeed/searchfeedhelper.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchFeed extends StatelessWidget {
  final String searchVal;
  ConstantColors constantColors = ConstantColors();

  SearchFeed({Key? key, required this.searchVal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: constantColors.blueGreyColor,
      appBar:
          Provider.of<SearchFeedHelper>(context, listen: false).appBar(context),
      body: Provider.of<SearchFeedHelper>(context, listen: false)
          .searchFeedBody(context: context, searchValue: searchVal),
    );
  }
}
