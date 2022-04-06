import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeed.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeedhelper.dart';
import 'package:mared_social/screens/SearchFeed/searchfeed.dart';
import 'package:mared_social/screens/SearchFeed/searchfeedhelper.dart';
import 'package:mared_social/widgets/items/category_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CategoryHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController searchController = TextEditingController();

  Widget headerCategory({required BuildContext context}) {
    return StatefulBuilder(builder: (context, innerState) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        color: constantColors.blueGreyColor,
        child: Stack(
          children: [
            //it doesn't make sense for this to change in realtime
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
                              .where('approvedForPosting',
                                  isEqualTo: !UserInfoManger.isAdmin())
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
    //it doens't make sense for this to change in realtime
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("category").get(),
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
                    return CategoryItem(
                      catDocSnap: catDocSnap,
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
