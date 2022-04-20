import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/auctionFeed/auctionpage.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/firebase_general_helpers.dart';
import 'package:mared_social/widgets/reusable/empty_search_result.dart';
import 'package:mared_social/widgets/reusable/interacted_user_item.dart';
import 'package:mared_social/widgets/reusable/post_result_item.dart';
import 'package:mared_social/widgets/reusable/user_result_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../Profile/profile.dart';

class UserSearchResultBody extends StatelessWidget {
  final String searchQuery;
  final String collectionName;
  final String searchIndexName;
  final bool isVendor;

  UserSearchResultBody(
      {Key? key,
      required this.searchQuery,
      required this.collectionName,
      required this.searchIndexName,
      required this.isVendor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return searchQuery.isEmpty
        ? NoSearchText(constantColors: constantColors, size: size)
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(collectionName)
                .where(searchIndexName,
                    arrayContains: searchQuery.toLowerCase())
                .where('store', isEqualTo: isVendor)
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
                    color: AppColors.backGroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.7,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var userData = snapshot.data!.docs[index];
                        return Container(
                          child: InteractedUserItem(
                              imageUrl: userData['userimage'],
                              itemUserId: userData['useruid'],
                              title: userData['username'],
                              subtitle: userData['useremail'],
                              shouldShowIcon: false,
                              leadingCallback: () {
                                if (userData['useruid'] !=
                                    UserInfoManger.getUserId()) {
                                  pushNewScreen(
                                    context,
                                    screen: AltProfile(
                                      userUid: userData['useruid'],
                                      userModel: UserModel(
                                          websiteLink: GeneralFirebaseHelpers
                                              .getStringSafely(
                                                  key: 'websiteLink',
                                                  doc: userData),
                                          bio: GeneralFirebaseHelpers
                                              .getStringSafely(
                                                  key: 'bio', doc: userData),
                                          uid: userData['useruid'],
                                          userName: userData['username'],
                                          photoUrl: userData['userimage'],
                                          email: userData['useremail'],
                                          fcmToken: "",

                                          ///later you have to give this the right value
                                          store: false),
                                    ),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                } else {
                                  pushNewScreen(
                                    context,
                                    screen: Profile(),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                }
                              }),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return EmptySearchResults();
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
                .where('approvedForPosting',
                    isEqualTo: !UserInfoManger.isAdmin())
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
                    color: AppColors.backGroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var postData = snapshot.data!.docs[index];
                      return PostResultData(
                        postData: postData,
                      );
                    },
                  ),
                );
              } else {
                return EmptySearchResults();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.3,
          width: size.width,
          child: Lottie.asset("assets/animations/searching.json"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("Use the search bar above to get what you desire",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: regularTextStyle(
                  fontSize: 13, textColor: AppColors.commentButtonColor)),
        ),
      ],
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
                                    type: PageTransitionType.rightToLeft));
                          },
                          leading: SizedBox(
                            height: size.height * 0.2,
                            width: size.width * 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Swiper(
                                loop: false,
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
