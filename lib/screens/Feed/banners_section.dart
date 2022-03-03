import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class BannersSection extends StatefulWidget {
  @override
  _BannersSectionState createState() => _BannersSectionState();
}

class _BannersSectionState extends State<BannersSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("banners")
          .where("enddate", isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .get(),
      builder: (context, bannerSnap) {
        if (bannerSnap.connectionState == ConnectionState.waiting ||
            !bannerSnap.hasData ||
            bannerSnap.data == null) {
          return LoadingWidget(constantColors: constantColors);
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Swiper(
                itemCount: bannerSnap.data!.docs.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: bannerSnap.data!.docs[index]['imageslist']
                                [0],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) {
                              return LoadingWidget(
                                  constantColors: constantColors);
                            },
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 20,
                        left: 20,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(bannerSnap.data!.docs[index]
                                          ['postid'])
                                      .get()
                                      .then((value) {
                                    Provider.of<AltProfileHelper>(context,
                                            listen: false)
                                        .showPostDetail(
                                            context: context,
                                            documentSnapshot: value);
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: constantColors.blueColor
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "View Post",
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: bannerSnap.data!.docs[index]
                                      ['useruid'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserId,
                              child: Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid: bannerSnap
                                                  .data!.docs[index]['useruid'],
                                            ),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  },
                                  child: Container(
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: constantColors.greenColor
                                          .withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      "Visit Profile",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                layout: SwiperLayout.DEFAULT,
                autoplay: true,
                duration: 5,
                curve: Curves.fastOutSlowIn,
              ),
            ),
          );
        }
      },
    );
  }
}
