import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final String userUid;
  AltProfile({Key? key, required this.userUid}) : super(key: key);

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar:
          Provider.of<AltProfileHelper>(context, listen: false).appBar(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.53,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: constantColors.blueGreyColor,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(userUid)
                      .snapshots(),
                  builder: (context, userDocSnap) {
                    if (userDocSnap.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Provider.of<AltProfileHelper>(context, listen: false)
                              .headerProfile(
                                  context: context,
                                  userDocSnap: userDocSnap,
                                  userUid: userUid),
                          Provider.of<AltProfileHelper>(context, listen: false)
                              .divider(),
                          Provider.of<AltProfileHelper>(context, listen: false)
                              .middleProfile(
                            context: context,
                            snapshot: userDocSnap,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userUid)
                .collection("posts")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, userPostSnap) {
              return SliverPadding(
                padding: const EdgeInsets.all(4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index.toInt() < userPostSnap.data!.docs.length) {
                        var userPostDocSnap = userPostSnap.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            Provider.of<AltProfileHelper>(context,
                                    listen: false)
                                .showPostDetail(
                                    context: context,
                                    documentSnapshot: userPostDocSnap);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: userPostDocSnap['imageslist']
                                          [index],
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
                                      (userPostDocSnap['imageslist'] as List)
                                          .length,
                                  itemHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                  itemWidth: MediaQuery.of(context).size.width,
                                  layout: SwiperLayout.DEFAULT,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Container(
      //     height: MediaQuery.of(context).size.height,
      //     width: MediaQuery.of(context).size.width,
      //     decoration: BoxDecoration(
      //       borderRadius: const BorderRadius.only(
      //         topLeft: Radius.circular(12),
      //         topRight: Radius.circular(12),
      //       ),
      //       color: constantColors.blueGreyColor,
      //     ),
      //     child: StreamBuilder<DocumentSnapshot>(
      //       stream: FirebaseFirestore.instance
      //           .collection("users")
      //           .doc(userUid)
      //           .snapshots(),
      //       builder: (context, userDocSnap) {
      //         if (userDocSnap.connectionState == ConnectionState.waiting) {
      //           return const Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         } else {
      //           return Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Provider.of<AltProfileHelper>(context, listen: false)
      //                   .headerProfile(
      //                       context: context,
      //                       userDocSnap: userDocSnap,
      //                       userUid: userUid),
      //               Provider.of<AltProfileHelper>(context, listen: false)
      //                   .divider(),
      //               Provider.of<AltProfileHelper>(context, listen: false)
      //                   .middleProfile(
      //                 context: context,
      //                 snapshot: userDocSnap,
      //               ),
      //               Provider.of<AltProfileHelper>(context, listen: false)
      //                   .footerProfile(
      //                 context: context,
      //                 userUid: userUid,
      //                 snapshot: userDocSnap,
      //               ),
      //             ],
      //           );
      //         }
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}
