import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/screens/Feed/feed_body.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backGroundColor,
      appBar: homeAppBar(
        context,
        leadingIconPath: 'assets/icons/home_search_icon.svg',
        actionIconPath: 'assets/icons/camera_icon.svg',
      ),
      body: FeedBody(),
    );
  }
}
