import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/mapscreen/categorymapscreen.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CatgeoryFeedHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late String categoryName;
  String get getCategoryName => categoryName;

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.8),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: CategoryMapScreen(
                        categoryName: categoryName,
                      ),
                      type: PageTransitionType.rightToLeft));
            },
            icon: const Icon(EvaIcons.mapOutline)),
      ],
      leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.rightToLeft));
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: constantColors.whiteColor,
          )),
      title: RichText(
        text: TextSpan(
          text: categoryName,
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: " Feed",
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

  getCategoryNameVal({required String categoryNameVal}) {
    categoryName = categoryNameVal;
    notifyListeners();
  }

  Widget categoryFeedBody(
      {required BuildContext context, required String category}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where('postcategory', isEqualTo: category)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingWidget(constantColors: constantColors),
                );
              } else if (snapshot.data!.docs.length == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset("assets/images/empty.png"),
                          height: 150,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "No posts for $category yet",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: constantColors.darkColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              } else {
                return loadPosts(context, snapshot);
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        return FeedPostItem(documentSnapshot: documentSnapshot);
      }).toList(),
    );
  }
}
