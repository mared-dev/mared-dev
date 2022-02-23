import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/auctionFeed/counterView.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:provider/provider.dart';

class PlaceBidHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor,
      title: Text(
        "Place your bid",
        style: TextStyle(
          color: constantColors.whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget warningHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: constantColors.blueGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.error_outline_outlined,
              color: constantColors.greenColor,
            ),
          ),
          Expanded(
            child: Text(
              "Attention - The purpose of this bid is to reach an appropriate price for the auction. Any attempts to manipulate or harm the integrity of the auction may result in legal prosecution from Mared or the auction advertiser",
              style: TextStyle(color: constantColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomAuctionPreview(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot}) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Provider.of<AuctionMapHelper>(context, listen: false)
            .showAuctionDetails(
                context: context, documentSnapshot: documentSnapshot);
      },
      child: Container(
        height: size.height * 0.1,
        decoration: BoxDecoration(
          color: constantColors.lightColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SizedBox(
                height: size.height,
                width: size.width * 0.25,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: documentSnapshot['imageslist'][0],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingWidget(constantColors: constantColors),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documentSnapshot['title'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      documentSnapshot['address'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseBid(
      {required BuildContext context, required DocumentSnapshot auctionDoc}) {
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, innerState) {
      return CounterView(
          auctionDoc: auctionDoc,
          auctionCurrentAmount: int.parse(auctionDoc['currentprice']) +
              int.parse(auctionDoc['minimumbid']),
          initNumber: int.parse(auctionDoc['minimumbid']),
          counterCallback: (int i) {},
          increaseCallback: () {
            innerState(() {});
          },
          decreaseCallback: () {
            innerState(() {});
          },
          minNumber: int.parse(auctionDoc['minimumbid']));
    });
  }
}
