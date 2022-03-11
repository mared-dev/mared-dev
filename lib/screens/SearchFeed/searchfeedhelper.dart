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
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SearchFeedHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late String searchVal;
  String get getSearchVal => searchVal;

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.8),
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: SplitPages(), type: PageTransitionType.rightToLeft));
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: constantColors.whiteColor,
          )),
      title: RichText(
        text: TextSpan(
          text: "Search: ",
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: searchVal,
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

  getSearchValue({required String searchValue}) {
    searchVal = searchValue;
    notifyListeners();
  }

  Widget searchFeedBody(
      {required BuildContext context, required String searchValue}) {
    print("see here == $searchValue");
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingWidget(constantColors: constantColors),
                );
              } else {
                return loadPosts(
                  context: context,
                  snapshot: snapshot,
                  searchTerm: searchValue,
                );
              }
            },
          ),
          height: MediaQuery.of(context).size.height * 0.87,
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
      {required BuildContext context,
      required AsyncSnapshot<QuerySnapshot> snapshot,
      required String searchTerm}) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot['caption']
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            documentSnapshot['description']
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase())) {
          return FeedPostItem(documentSnapshot: documentSnapshot);
        } else {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        }
      }).toList(),
    );
  }
}
