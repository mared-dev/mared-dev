import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/auctionFeed/auctionPageWidgets.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/auctionoptions.dart';
import 'package:provider/provider.dart';

class AuctionPage extends StatefulWidget {
  final String auctionId;

  const AuctionPage({Key? key, required this.auctionId}) : super(key: key);
  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  ConstantColors constantColors = ConstantColors();
  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("auctions")
          .doc(widget.auctionId)
          .snapshots(),
      builder: (context, auctionDoc) {
        if (auctionDoc.connectionState == ConnectionState.waiting) {
          return LoadingWidget(constantColors: constantColors);
        } else {
          DocumentSnapshot auctionDocSnap = auctionDoc.data!;
          Provider.of<AuctionFuctions>(context, listen: false).addAuctionView(
              userUid: auctionDocSnap['useruid'],
              context: context,
              auctionID: auctionDocSnap['auctionid'],
              subDocId: Provider.of<Authentication>(context, listen: false)
                  .getUserId);
          if (DateTime.now().isBefore(
              (auctionDoc.data!['startdate'] as Timestamp).toDate())) {
            return AuctionPending(
              auctionDocSnap: auctionDocSnap,
              constantColors: constantColors,
              size: size,
            );
          } else {
            int endTime = (auctionDocSnap['enddate'] as Timestamp)
                    .toDate()
                    .millisecondsSinceEpoch +
                1000 * 30;

            bool auctionEnded =
                endTime < DateTime.now().millisecondsSinceEpoch + 1000 * 30;
            return auctionEnded
                ? Container(
                    height: 10,
                    width: 10,
                    color: constantColors.yellowColor,
                  )
                : AuctionStarted(
                    constantColors: constantColors,
                    size: size,
                    auctionDocSnap: auctionDocSnap,
                    endTime: endTime);
          }
        }
      },
    );
  }
}
