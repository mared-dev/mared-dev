import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeed.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeedhelper.dart';
import 'package:mared_social/screens/SearchFeed/searchfeed.dart';
import 'package:mared_social/screens/SearchFeed/searchfeedhelper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CategoryHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController searchController = TextEditingController();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.blueGreyColor,
      centerTitle: true,
      leading: const SizedBox(
        height: 0,
        width: 0,
      ),
      title: RichText(
        text: TextSpan(
          text: "Mared ",
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: "Categories",
              style: TextStyle(
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerCategory({required BuildContext context}) {
    return StatefulBuilder(builder: (context, innerState) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        color: constantColors.blueGreyColor,
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("categoryHeader")
                  .limit(1)
                  .snapshots(),
              builder: (context, headerSnap) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: headerSnap.data!.docs[0]['image'],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              LoadingWidget(constantColors: constantColors),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 20,
              right: 16,
              left: 16,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: constantColors.whiteColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (value) {
                        innerState(() {
                          searchController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            innerState(() {
                              searchController.text = "";
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: constantColors.darkColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          EvaIcons.searchOutline,
                          color: constantColors.darkColor,
                          size: 20,
                        ),
                        hintText: "Describe what you're looking for...",
                        hintStyle: TextStyle(
                            color: constantColors.darkColor, fontSize: 16),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: searchController.text != "",
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: constantColors.whiteColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 130,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("posts")
                              .where('searchindex',
                                  arrayContains:
                                      searchController.text.toLowerCase())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: LoadingWidget(
                                    constantColors: constantColors),
                              );
                            } else {
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    "We looked everywhere and couldnt find what you're looking for on Mared",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: constantColors.darkColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              } else {
                                return ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot documentSnapshot) {
                                    return ListTile(
                                      onTap: () async {
                                        // * push to Search screen based on description of item
                                        await Provider.of<SearchFeedHelper>(
                                                context,
                                                listen: false)
                                            .getSearchValue(
                                                searchValue:
                                                    searchController.text);

                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: SearchFeed(
                                                  searchVal:
                                                      searchController.text,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeft));
                                      },
                                      title: Text(
                                        documentSnapshot['caption'],
                                        style: TextStyle(
                                          color: constantColors.darkColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        documentSnapshot['description'],
                                        style: TextStyle(
                                          color: constantColors.blueGreyColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget middleCategory({required BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("category").snapshots(),
      builder: (context, catSnaps) {
        if (catSnaps.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.0,
                children: catSnaps.data!.docs.map(
                  (catDocSnap) {
                    return InkWell(
                      onTap: () async {
                        // * Push to Category screen
                        await Provider.of<CatgeoryFeedHelper>(context,
                                listen: false)
                            .getCategoryNameVal(
                                categoryNameVal: catDocSnap['categoryname']);

                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: CategoryFeed(
                                  categoryName: catDocSnap['categoryname'],
                                ),
                                type: PageTransitionType.rightToLeft));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: constantColors.blueColor,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 90,
                                width: 90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: catDocSnap['categoryimage'],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            LoadingWidget(
                                                constantColors: constantColors),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 6,
                            left: 6,
                            child: Center(
                              child: Text(
                                catDocSnap['categoryname'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
