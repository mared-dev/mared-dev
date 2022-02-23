import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/auctionFeed/auctionProductMap.dart';
import 'package:mared_social/screens/auctionFeed/placebidscreen.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/auctionoptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AuctionStarted extends StatelessWidget {
  AuctionStarted({
    Key? key,
    required this.constantColors,
    required this.size,
    required this.auctionDocSnap,
    required this.endTime,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;
  final DocumentSnapshot<Object?> auctionDocSnap;
  final int endTime;

  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: PlaceBidScreen(
                    AuctionDocSnap: auctionDocSnap,
                  ),
                  type: PageTransitionType.rightToLeft));
        },
        child: Container(
          height: size.height * 0.1,
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              "Place Your Bid",
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: constantColors.blueGreyColor,
      body: SingleChildScrollView(
        child: SafeArea(
          top: true,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: size.height * 0.35,
                    color: constantColors.darkColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Swiper(
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: auctionDocSnap['imageslist'][index],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => SizedBox(
                              height: 50,
                              width: 50,
                              child:
                                  LoadingWidget(constantColors: constantColors),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          );
                        },
                        itemCount:
                            (auctionDocSnap['imageslist'] as List).length,
                        itemHeight: MediaQuery.of(context).size.height * 0.3,
                        itemWidth: MediaQuery.of(context).size.width,
                        layout: SwiperLayout.DEFAULT,
                        indicatorLayout: PageIndicatorLayout.SCALE,
                        pagination: SwiperPagination(
                          margin: const EdgeInsets.all(10),
                          builder: DotSwiperPaginationBuilder(
                            color: constantColors.whiteColor.withOpacity(0.6),
                            activeColor:
                                constantColors.darkColor.withOpacity(0.6),
                            size: 15,
                            activeSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    userUid: auctionDocSnap['useruid'],
                                    context: context,
                                    auctionID: auctionDocSnap['auctionid'],
                                    subDocId: Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserId,
                                  );
                                } else {
                                  Provider.of<FeedHelpers>(context,
                                          listen: false)
                                      .IsAnonBottomSheet(context);
                                }
                              },
                              onLongPress: () {
                                Provider.of<AuctionFuctions>(context,
                                        listen: false)
                                    .showLikes(
                                        context: context,
                                        auctionId: auctionDocSnap['auctionid']);
                              },
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("auctions")
                                      .doc(auctionDocSnap['auctionid'])
                                      .collection('likes')
                                      .snapshots(),
                                  builder: (context, likeSnap) {
                                    return SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                likeSnap.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
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
                                Provider.of<AuctionFuctions>(context,
                                        listen: false)
                                    .showCommentsSheet(
                                        snapshot: auctionDocSnap,
                                        context: context,
                                        auctionId: auctionDocSnap['auctionid']);
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
                                        size: 20,
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("auctions")
                                            .doc(auctionDocSnap['auctionid'])
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, commentSnap) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              commentSnap.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
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
                            InkWell(
                              onTap: () {
                                Provider.of<AuctionFuctions>(context,
                                        listen: false)
                                    .showLikes(
                                        context: context,
                                        auctionId: auctionDocSnap['auctionid']);
                              },
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("auctions")
                                    .doc(auctionDocSnap['auctionid'])
                                    .collection('views')
                                    .snapshots(),
                                builder: (context, viewSnap) {
                                  return SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.eye,
                                            color: constantColors.whiteColor,
                                            size: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              viewSnap.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: CountdownTimer(
                        endTime: endTime,
                        widgetBuilder: (context, CurrentRemainingTime? time) {
                          return Text(
                            "Auction Ending in: ${time!.days} days, ${time.hours} hrs, ${time.min} mins & ${time.sec} secs",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: constantColors.lightColor,
                    ),
                    Text(
                      auctionDocSnap['title'].toString().capitalize(),
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: size.width,
                        child: ExpandableText(
                          text: auctionDocSnap['description']
                              .toString()
                              .capitalize(),
                          textStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          (auctionDocSnap['time'] as Timestamp)
                              .toDate()
                              .toString()
                              .substring(0, 10),
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: constantColors.lightColor,
                    ),
                    Container(
                      height: size.height * 0.12,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: constantColors.darkColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Current Price",
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${auctionDocSnap['currentprice']} AED",
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: constantColors.lightColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PriceWidget(
                          size: size,
                          title: "Starting Price",
                          amount: auctionDocSnap['startingprice'],
                          constantColors: constantColors,
                          auctionDocSnap: auctionDocSnap,
                        ),
                        PriceWidget(
                          size: size,
                          title: "Minimum Bid amount",
                          amount: auctionDocSnap['minimumbid'],
                          constantColors: constantColors,
                          auctionDocSnap: auctionDocSnap,
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: SizedBox(
                        height: size.height * 0.3,
                        width: size.width,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Placed Bids",
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "See all",
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: size.width,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("auctions")
                                      .doc(auctionDocSnap.id)
                                      .collection("bids")
                                      .orderBy('time', descending: true)
                                      .snapshots(),
                                  builder: (context, bidSnap) {
                                    if (bidSnap.data!.docs.isEmpty) {
                                      return Container(
                                        alignment: Alignment.center,
                                        height: size.height * 0.24,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          color: constantColors.darkColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "No Bids Placed Yet",
                                          style: TextStyle(
                                            color: constantColors.greenColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: size.height * 0.24,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          color: constantColors.darkColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListView.builder(
                                          itemCount: bidSnap.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            var bidSnapData =
                                                bidSnap.data!.docs[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ListTile(
                                                trailing: Text(
                                                  "AED ${bidSnapData['bidamount']}",
                                                  style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: bidSnapData[
                                                        'userimage'],
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: LoadingWidget(
                                                          constantColors:
                                                              constantColors),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                                title: Text(
                                                  bidSnapData['username'],
                                                  style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: constantColors.lightColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 30,
                            color: constantColors.blueColor,
                          ),
                          Expanded(
                            child: Text(
                              auctionDocSnap['address'].toString().capitalize(),
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
                    StatefulBuilder(
                      builder: (context, innerState) {
                        Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
                        LatLng _center = LatLng(
                          double.parse(auctionDocSnap['lat']),
                          double.parse(auctionDocSnap['lng']),
                        );

                        void _onMapCreated(GoogleMapController controller) {
                          googleMapController = controller;

                          final marker = Marker(
                            markerId: MarkerId(auctionDocSnap.id),
                            onTap: () {
                              print("okay");
                            },
                            position: LatLng(
                              double.parse(auctionDocSnap['lat']),
                              double.parse(auctionDocSnap['lng']),
                            ),
                            infoWindow: InfoWindow(
                              title: 'title',
                              snippet: 'address',
                            ),
                          );

                          innerState(() {
                            markers[MarkerId(auctionDocSnap.id)] = marker;
                          });
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AuctionProductMapScreen(
                                        docSnap: auctionDocSnap,
                                        docSnapId: auctionDocSnap.id),
                                    type: PageTransitionType.leftToRight));
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: size.height * 0.3,
                                width: size.width,
                                color: constantColors.whiteColor,
                                child: AbsorbPointer(
                                  absorbing: true,
                                  child: GoogleMap(
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: false,
                                    mapToolbarEnabled: true,
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: 14.0,
                                    ),
                                    markers: markers.values.toSet(),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Center(
                                    child: Icon(
                                  Icons.location_on_rounded,
                                  size: 40,
                                  color: constantColors.redColor,
                                )),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: constantColors.lightColor,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 30,
                            color: constantColors.blueColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "The legal integrity of the auction is the sole responsibility of the auction owner (${auctionDocSnap['username']}) and we strongly advise not to make any payments to the auction owner before verifying the quality and rightful ownership of the product / service being offered. Mared does not participate in any financial transaction between the auction owner and the bidder.",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.size,
    required this.constantColors,
    required this.auctionDocSnap,
    required this.title,
    required this.amount,
  }) : super(key: key);

  final Size size;
  final String title;
  final String amount;
  final ConstantColors constantColors;
  final DocumentSnapshot<Object?> auctionDocSnap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.12,
      width: size.width * 0.45,
      decoration: BoxDecoration(
        color: constantColors.darkColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: constantColors.greenColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            "$amount AED",
            style: TextStyle(
              color: constantColors.greenColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class AuctionPending extends StatelessWidget {
  const AuctionPending({
    Key? key,
    required this.constantColors,
    required this.size,
    required this.auctionDocSnap,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;
  final DocumentSnapshot<Object?> auctionDocSnap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: constantColors.darkColor,
                )),
            backgroundColor: constantColors.blueGreyColor,
            expandedHeight: size.height * 0.35,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                top: true,
                child: Container(
                  color: constantColors.darkColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Swiper(
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: auctionDocSnap['imageslist'][index],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            height: 50,
                            width: 50,
                            child:
                                LoadingWidget(constantColors: constantColors),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                      itemCount: (auctionDocSnap['imageslist'] as List).length,
                      itemHeight: MediaQuery.of(context).size.height * 0.3,
                      itemWidth: MediaQuery.of(context).size.width,
                      layout: SwiperLayout.DEFAULT,
                      indicatorLayout: PageIndicatorLayout.SCALE,
                      pagination: SwiperPagination(
                        margin: const EdgeInsets.all(10),
                        builder: DotSwiperPaginationBuilder(
                          color: constantColors.whiteColor.withOpacity(0.6),
                          activeColor:
                              constantColors.darkColor.withOpacity(0.6),
                          size: 15,
                          activeSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              children: [
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
                                userUid: auctionDocSnap['useruid'],
                                context: context,
                                auctionID: auctionDocSnap['auctionid'],
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
                                    auctionId: auctionDocSnap['auctionid']);
                          },
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("auctions")
                                  .doc(auctionDocSnap['auctionid'])
                                  .collection('likes')
                                  .snapshots(),
                              builder: (context, likeSnap) {
                                return SizedBox(
                                  width: 60,
                                  height: 60,
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
                                          size: 20,
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
                                              fontSize: 16,
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
                                    snapshot: auctionDocSnap,
                                    context: context,
                                    auctionId: auctionDocSnap['auctionid']);
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
                                    size: 20,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("auctions")
                                        .doc(auctionDocSnap['auctionid'])
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
                                            fontSize: 16,
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
                        InkWell(
                          onTap: () {
                            Provider.of<AuctionFuctions>(context, listen: false)
                                .showLikes(
                                    context: context,
                                    auctionId: auctionDocSnap['auctionid']);
                          },
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("auctions")
                                .doc(auctionDocSnap['auctionid'])
                                .collection('views')
                                .snapshots(),
                            builder: (context, viewSnap) {
                              return SizedBox(
                                width: 60,
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.eye,
                                        color: constantColors.whiteColor,
                                        size: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          viewSnap.data!.docs.length.toString(),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
