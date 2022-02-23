import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/auctionFeed/submitAuction.dart';
import 'package:page_transition/page_transition.dart';

class CreateAuctionScreen extends StatelessWidget {
  CreateAuctionScreen({Key? key}) : super(key: key);
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: constantColors.blueGreyColor,
        title: Text(
          "Create an Auction",
          style: TextStyle(
            color: constantColors.blueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(EvaIcons.arrowBackOutline),
          color: constantColors.greenColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "Ahlan! What would you like to list today?",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Select the category that suits your auction",
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("auctionCategories")
                    .orderBy("name", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget(constantColors: constantColors);
                  } else {
                    return SizedBox(
                      height: size.height * 0.7,
                      width: size.width,
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 1.3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: SubmitAuctionScreen(
                                          auctionCategory: snapshot
                                              .data!.docs[index]["name"],
                                        ),
                                        type: PageTransitionType.rightToLeft));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        height: size.height * 0.113,
                                        child: Lottie.network(
                                          snapshot.data!.docs[index]["url"],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]["name"],
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: constantColors.blueGreyColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
