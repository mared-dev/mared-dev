import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/auctionFeed/auctionpage.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyBids extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        backgroundColor: constantColors.blueGreyColor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Bids",
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(Provider.of<Authentication>(context, listen: false).getUserId)
            .collection("myBids")
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, bidSnaps) {
          if (bidSnaps.connectionState == ConnectionState.waiting) {
            return LoadingWidget(constantColors: constantColors);
          } else {
            if (bidSnaps.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No Bids Placed Yet",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(5),
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  color: constantColors.darkColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListView.builder(
                  itemCount: bidSnaps.data!.docs.length,
                  itemBuilder: (context, index) {
                    var bidData = bidSnaps.data!.docs[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AuctionPage(
                                  auctionId: bidData['auctionid'],
                                ),
                                type: PageTransitionType.bottomToTop));
                      },
                      trailing: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("auctions")
                            .doc(bidData['auctionid'])
                            .collection("bids")
                            .orderBy("time", descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingWidget(
                                constantColors: constantColors);
                          } else {
                            if (snapshot.data!.docs[0]['useruid'] ==
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId) {
                              if (index == 0) {
                                return Icon(
                                  FontAwesomeIcons.trophy,
                                  color: constantColors.yellowColor,
                                );
                              } else {
                                return const SizedBox(
                                  height: 0,
                                  width: 0,
                                );
                              }
                            } else {
                              return Icon(
                                FontAwesomeIcons.frownOpen,
                                color: constantColors.redColor,
                              );
                            }
                          }
                        },
                      ),
                      leading: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Swiper(
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: bidData['imageslist'][index],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: LoadingWidget(
                                      constantColors: constantColors),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            );
                          },
                          itemCount: (bidData['imageslist'] as List).length,
                          itemHeight: MediaQuery.of(context).size.height * 0.3,
                          itemWidth: MediaQuery.of(context).size.width,
                          layout: SwiperLayout.DEFAULT,
                        ),
                      ),
                      title: Text(
                        bidData['title'],
                        maxLines: 1,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                        ),
                      ),
                      subtitle: Text(
                        "Bid placed: AED ${bidData['bidamount']}",
                        maxLines: 1,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
