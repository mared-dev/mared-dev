import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/screens/Categories/categoryHelpers.dart';
import 'package:mared_social/screens/SearchFeed/searchfeed.dart';
import 'package:mared_social/screens/SearchFeed/searchfeedhelper.dart';
import 'package:mared_social/screens/searchPage/searchPage.dart';
import 'package:mared_social/widgets/items/category_item.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: homeAppBar(
        context,
        title: 'MARED CATEGORIES',
        leadingIcon: SvgPicture.asset(
          'assets/icons/home_search_icon.svg',
          width: 18.w,
          height: 18.h,
        ),
        leadingCallback: () {
          pushNewScreen(
            context,
            screen: SearchPage(),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 36.h,
            ),
            // _searchSection(),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("category").get(),
              builder: (context, catSnaps) {
                if (catSnaps.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 36.w),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 0.8,
                        children: catSnaps.data!.docs.map<Widget>(
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
            )
          ],
        ),
      ),
    );
  }

  ///search section keep for later
  // Widget _searchSection() {
  //   return StatefulBuilder(builder: (context, innerState) {
  //     return Column(
  //       children: [
  //         Container(
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: constantColors.whiteColor.withOpacity(0.9),
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: TextField(
  //             controller: searchController,
  //             onSubmitted: (value) {
  //               innerState(() {
  //                 searchController.text = value;
  //               });
  //             },
  //             decoration: InputDecoration(
  //               suffixIcon: IconButton(
  //                 onPressed: () {
  //                   searchController.clear();
  //                   innerState(() {
  //                     searchController.text = "";
  //                   });
  //                 },
  //                 icon: Icon(
  //                   Icons.close,
  //                   color: constantColors.darkColor,
  //                 ),
  //               ),
  //               prefixIcon: Icon(
  //                 EvaIcons.searchOutline,
  //                 color: constantColors.darkColor,
  //                 size: 20,
  //               ),
  //               hintText: "Describe what you're looking for...",
  //               hintStyle:
  //                   TextStyle(color: constantColors.darkColor, fontSize: 16),
  //             ),
  //           ),
  //         ),
  //         Visibility(
  //           visible: searchController.text != "",
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 5.0),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: constantColors.whiteColor.withOpacity(0.9),
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //               height: 130,
  //               child: StreamBuilder<QuerySnapshot>(
  //                 stream: FirebaseFirestore.instance
  //                     .collection("posts")
  //                     .where('searchindex',
  //                         arrayContains: searchController.text.toLowerCase())
  //                     .snapshots(),
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Center(
  //                       child: LoadingWidget(constantColors: constantColors),
  //                     );
  //                   } else {
  //                     if (snapshot.data!.docs.isEmpty) {
  //                       return Center(
  //                         child: Text(
  //                           "We looked everywhere and couldnt find what you're looking for on Mared",
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: constantColors.darkColor,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       );
  //                     } else {
  //                       return ListView(
  //                         children: snapshot.data!.docs
  //                             .map((DocumentSnapshot documentSnapshot) {
  //                           return ListTile(
  //                             onTap: () async {
  //                               // * push to Search screen based on description of item
  //                               await Provider.of<SearchFeedHelper>(context,
  //                                       listen: false)
  //                                   .getSearchValue(
  //                                       searchValue: searchController.text);
  //
  //                               Navigator.pushReplacement(
  //                                   context,
  //                                   PageTransition(
  //                                       child: SearchFeed(
  //                                         searchVal: searchController.text,
  //                                       ),
  //                                       type: PageTransitionType.rightToLeft));
  //                             },
  //                             title: Text(
  //                               documentSnapshot['caption'],
  //                               style: TextStyle(
  //                                 color: constantColors.darkColor,
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             subtitle: Text(
  //                               documentSnapshot['description'],
  //                               style: TextStyle(
  //                                 color: constantColors.blueGreyColor,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           );
  //                         }).toList(),
  //                       );
  //                     }
  //                   }
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   });
  // }
}
