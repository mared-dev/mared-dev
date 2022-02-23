import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Categories/categoryHelpers.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Provider.of<CategoryHelper>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<CategoryHelper>(context, listen: false)
                .headerCategory(context: context),
            Provider.of<CategoryHelper>(context, listen: false)
                .middleCategory(context: context),
          ],
        ),
      ),
    );
  }
}
