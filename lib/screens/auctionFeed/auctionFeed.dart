import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/auctionFeed/auctionfeedHelper.dart';
import 'package:provider/provider.dart';

class AuctionFeed extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Provider.of<AuctionFeedHelper>(context, listen: false)
          .auctionFeedBody(context),
      backgroundColor: constantColors.darkColor,
      floatingActionButton:
          Provider.of<AuctionFeedHelper>(context, listen: false)
              .postAuction(context),
    );
  }
}
