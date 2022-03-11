import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/widgets/items/feed_body.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: constantColors.blueGreyColor,
      appBar: homeAppBar(context),
      body: FeedBody(),
    );
  }
}
