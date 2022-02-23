import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/auctionFeed/auctionpage.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/auctionoptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AuctionMapHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  showAuctionDetails(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot}) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        Provider.of<AuctionFuctions>(context, listen: false)
            .showTimeAgo(documentSnapshot['time']);

        int endTime = (documentSnapshot['enddate'] as Timestamp)
                .toDate()
                .millisecondsSinceEpoch +
            1000 * 30;
        int startTime = (documentSnapshot['startdate'] as Timestamp)
                .toDate()
                .millisecondsSinceEpoch +
            1000 * 30;

        return SafeArea(
          bottom: true,
          child: Container(
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (documentSnapshot['useruid'] !=
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userUid: documentSnapshot['useruid'],
                                    ),
                                    type: PageTransitionType.bottomToTop));
                          }
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: documentSnapshot['userimage'],
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  LoadingWidget(constantColors: constantColors),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      documentSnapshot['title'],
                                      style: TextStyle(
                                        color: constantColors.greenColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        ", ${documentSnapshot['address']}",
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: constantColors.lightColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: RichText(
                                  text: TextSpan(
                                    text: documentSnapshot['username'],
                                    style: TextStyle(
                                      color: constantColors.blueColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            " , ${Provider.of<AuctionFuctions>(context, listen: false).getImageTimePosted.toString()}",
                                        style: TextStyle(
                                          color: constantColors.lightColor
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AuctionPage(
                                auctionId: documentSnapshot['auctionid'],
                              ),
                              type: PageTransitionType.bottomToTop));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.44,
                          width: MediaQuery.of(context).size.width,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: documentSnapshot['imageslist'][index],
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
                              );
                            },
                            itemCount:
                                (documentSnapshot['imageslist'] as List).length,
                            itemHeight:
                                MediaQuery.of(context).size.height * 0.3,
                            itemWidth: MediaQuery.of(context).size.width,
                            layout: SwiperLayout.DEFAULT,
                            indicatorLayout: PageIndicatorLayout.SCALE,
                            pagination: SwiperPagination(
                              margin: EdgeInsets.all(10),
                              builder: DotSwiperPaginationBuilder(
                                color:
                                    constantColors.whiteColor.withOpacity(0.6),
                                activeColor:
                                    constantColors.darkColor.withOpacity(0.6),
                                size: 15,
                                activeSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: Container(
                            alignment: Alignment.center,
                            height: size.height * 0.04,
                            width: size.width * 0.38,
                            decoration: BoxDecoration(
                              color: constantColors.darkColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DateTime.now().isBefore(
                                    (documentSnapshot['startdate'] as Timestamp)
                                        .toDate())
                                ? CountdownTimer(
                                    endTime: startTime,
                                    widgetBuilder:
                                        (context, CurrentRemainingTime? time) {
                                      return Text(
                                        "Starting in ${time!.days} days",
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                        ),
                                      );
                                    },
                                  )
                                : CountdownTimer(
                                    endTime: endTime,
                                    widgetBuilder:
                                        (context, CurrentRemainingTime? time) {
                                      return Text(
                                        "Ending in ${time!.days} days",
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            if (Provider.of<Authentication>(context,
                                        listen: false)
                                    .getIsAnon ==
                                false) {
                              Provider.of<AuctionFuctions>(context,
                                      listen: false)
                                  .addAuctionLike(
                                userUid: documentSnapshot['useruid'],
                                context: context,
                                auctionID: documentSnapshot['auctionid'],
                                subDocId: Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId,
                              );
                            } else {
                              Provider.of<FeedHelpers>(context, listen: false)
                                  .IsAnonBottomSheet(context);
                            }
                          },
                          onLongPress: () {
                            Provider.of<AuctionFuctions>(context, listen: false)
                                .showLikes(
                                    context: context,
                                    auctionId: documentSnapshot['auctionid']);
                          },
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("auctions")
                                  .doc(documentSnapshot['auctionid'])
                                  .collection('likes')
                                  .snapshots(),
                              builder: (context, likeSnap) {
                                return SizedBox(
                                  width: 60,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          likeSnap.data!.docs.any((element) =>
                                                  element.id ==
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserId)
                                              ? EvaIcons.heart
                                              : EvaIcons.heartOutline,
                                          color: constantColors.redColor,
                                          size: 18,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            likeSnap.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<AuctionFuctions>(context, listen: false)
                                .showCommentsSheet(
                                    snapshot: documentSnapshot,
                                    context: context,
                                    auctionId: documentSnapshot['auctionid']);
                          },
                          child: SizedBox(
                            width: 60,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.comment,
                                    color: constantColors.blueColor,
                                    size: 16,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("auctions")
                                        .doc(documentSnapshot['auctionid'])
                                        .collection('comments')
                                        .snapshots(),
                                    builder: (context, commentSnap) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          commentSnap.data!.docs.length
                                              .toString(),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Provider.of<Authentication>(context, listen: false)
                                    .getUserId ==
                                documentSnapshot['useruid']
                            ? IconButton(
                                onPressed: () {
                                  Provider.of<AuctionFuctions>(context,
                                          listen: false)
                                      .showAuctionOptions(
                                          context: context,
                                          auctionId:
                                              documentSnapshot['auctionid']);

                                  Provider.of<AuctionFuctions>(context,
                                          listen: false)
                                      .getImageDescription(
                                          documentSnapshot['description']);
                                },
                                icon: Icon(EvaIcons.moreVertical,
                                    color: constantColors.whiteColor),
                              )
                            : const SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 5,
                  ),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      documentSnapshot['description'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
