import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeedhelper.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CategoryFeed extends StatelessWidget {
  final String categoryName;
  ConstantColors constantColors = ConstantColors();

  CategoryFeed({Key? key, required this.categoryName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: constantColors.blueGreyColor,
      appBar: Provider.of<CatgeoryFeedHelper>(context, listen: false)
          .appBar(context),
      body: Provider.of<CatgeoryFeedHelper>(context, listen: false)
          .categoryFeedBody(context: context, category: categoryName),
    );
  }
}
