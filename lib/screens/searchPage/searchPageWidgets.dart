import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/auctionFeed/auctionpage.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserSearch extends StatelessWidget {
  final String userSearchVal;
  final ConstantColors constantColors = ConstantColors();

  UserSearch({Key? key, required this.userSearchVal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return userSearchVal.isEmpty
        ? NoSearchText(constantColors: constantColors, size: size)
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('usersearchindex',
                    arrayContains: userSearchVal.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget(constantColors: constantColors);
              } else if (snapshot.data!.docs.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userData = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          onTap: () {
                            if (userData['useruid'] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userUid: userData['useruid'],
                                      ),
                                      type: PageTransitionType.bottomToTop));
                            } else {
                              Provider.of<FeedHelpers>(context, listen: false)
                                  .IsAnonBottomSheet(context);
                            }
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: userData['userimage'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                height: 50,
                                width: 50,
                                child: LoadingWidget(
                                    constantColors: constantColors),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          title: Text(
                            userData['username'],
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: Lottie.asset(
                          "assets/animations/empty.json",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Center(
                          child: Text(
                            "No users found, please use the above search bar to find your desired users",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          );
  }
}

class VendorSearch extends StatelessWidget {
  final String vendorSearchVal;
  final ConstantColors constantColors = ConstantColors();

  VendorSearch({Key? key, required this.vendorSearchVal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return vendorSearchVal.isEmpty
        ? NoSearchText(constantColors: constantColors, size: size)
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('usersearchindex',
                    arrayContains: vendorSearchVal.toLowerCase())
                .where('store', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget(constantColors: constantColors);
              } else if (snapshot.data!.docs.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var vendorData = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          onTap: () {
                            if (vendorData['useruid'] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userUid: vendorData['useruid'],
                                      ),
                                      type: PageTransitionType.bottomToTop));
                            } else {
                              Provider.of<FeedHelpers>(context, listen: false)
                                  .IsAnonBottomSheet(context);
                            }
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: vendorData['userimage'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                height: 50,
                                width: 50,
                                child: LoadingWidget(
                                    constantColors: constantColors),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          title: Text(
                            vendorData['username'],
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                          subtitle: Text(
                            vendorData['useremail'],
                            style: TextStyle(
                              color: constantColors.blueColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: Lottie.asset(
                          "assets/animations/empty.json",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Center(
                          child: Text(
                            "No vendors found, please use the above search bar to find your desired vendor",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          );
  }
}

class PostSearch extends StatelessWidget {
  final String postSearchVal;
  final ConstantColors constantColors = ConstantColors();

  PostSearch({Key? key, required this.postSearchVal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return postSearchVal.isEmpty
        ? NoSearchText(constantColors: constantColors, size: size)
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where('searchindex',
                    arrayContains: postSearchVal.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget(constantColors: constantColors);
              } else if (snapshot.data!.docs.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var postData = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          onTap: () {
                            Provider.of<AltProfileHelper>(context,
                                    listen: false)
                                .showPostDetail(
                                    context: context,
                                    documentSnapshot: postData);
                          },
                          leading: SizedBox(
                            height: size.height * 0.2,
                            width: size.width * 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: postData['imageslist'][index],
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
                                    (postData['imageslist'] as List).length,
                                itemHeight:
                                    MediaQuery.of(context).size.height * 0.3,
                                itemWidth: MediaQuery.of(context).size.width,
                                layout: SwiperLayout.DEFAULT,
                              ),
                            ),
                          ),
                          title: Text(
                            postData['caption'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                          subtitle: Text(
                            postData['description'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: constantColors.blueColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: Lottie.asset(
                          "assets/animations/empty.json",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Center(
                          child: Text(
                            "No posts found, please use the above search bar to find your desired item",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          );
  }
}

class NoSearchText extends StatelessWidget {
  const NoSearchText({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: constantColors.darkColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.3,
            width: size.width,
            child: Lottie.asset("assets/animations/searching.json"),
          ),
          Text(
            "Use the search bar above to get what you desire",
            style: TextStyle(
              color: constantColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AuctionSearch extends StatelessWidget {
  final String auctionSearchVal;
  final ConstantColors constantColors = ConstantColors();

  AuctionSearch({Key? key, required this.auctionSearchVal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return auctionSearchVal.isEmpty
        ? NoSearchText(constantColors: constantColors, size: size)
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("auctions")
                .where('searchindex',
                    arrayContains: auctionSearchVal.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget(constantColors: constantColors);
              } else if (snapshot.data!.docs.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var auctionData = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AuctionPage(
                                      auctionId: auctionData['auctionid'],
                                    ),
                                    type: PageTransitionType.bottomToTop));
                          },
                          leading: SizedBox(
                            height: size.height * 0.2,
                            width: size.width * 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: auctionData['imageslist'][index],
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
                                    (auctionData['imageslist'] as List).length,
                                itemHeight:
                                    MediaQuery.of(context).size.height * 0.3,
                                itemWidth: MediaQuery.of(context).size.width,
                                layout: SwiperLayout.DEFAULT,
                              ),
                            ),
                          ),
                          title: Text(
                            auctionData['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                          subtitle: Text(
                            auctionData['description'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: constantColors.blueColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: Lottie.asset(
                          "assets/animations/empty.json",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Center(
                          child: Text(
                            "No auctions found, please use the above search bar to find your desired auction item",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          );
  }
}
