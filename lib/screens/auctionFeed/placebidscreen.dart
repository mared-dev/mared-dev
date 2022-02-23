import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/auctionFeed/placebidhelper.dart';
import 'package:provider/provider.dart';

class PlaceBidScreen extends StatefulWidget {
  final DocumentSnapshot AuctionDocSnap;
  const PlaceBidScreen({Key? key, required this.AuctionDocSnap})
      : super(key: key);

  @override
  _PlaceBidScreenState createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Provider.of<PlaceBidHelpers>(context, listen: false)
          .bottomAuctionPreview(
              context: context, documentSnapshot: widget.AuctionDocSnap),
      backgroundColor: constantColors.darkColor,
      appBar:
          Provider.of<PlaceBidHelpers>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<PlaceBidHelpers>(context, listen: false)
                .warningHeader(context),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Provider.of<PlaceBidHelpers>(context, listen: false)
                  .chooseBid(
                context: context,
                auctionDoc: widget.AuctionDocSnap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
