import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/mapscreen/categorymapscreen.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
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
                    child: SplitPages(), type: PageTransitionType.rightToLeft));
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
        Provider.of<PostFunctions>(context, listen: false)
            .showTimeAgo(documentSnapshot['time']);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (documentSnapshot['useruid'] !=
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AltProfile(
                                    userUid: documentSnapshot['useruid'],
                                  ),
                                  type: PageTransitionType.bottomToTop));
                        }
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: documentSnapshot['userimage'],
                            progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                LoadingWidget(constantColors: constantColors),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                documentSnapshot['caption'],
                                style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: documentSnapshot['username'],
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          " , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}",
                                      style: TextStyle(
                                        color: constantColors.lightColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Provider.of<PostFunctions>(context, listen: false)
                            .showAwardsPresenter(
                                context: context,
                                postId: documentSnapshot['postid']);
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.045,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("posts")
                              .doc(documentSnapshot['postid'])
                              .collection("awards")
                              .snapshots(),
                          builder: (context, awardSnaps) {
                            if (awardSnaps.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: awardSnaps.data!.docs
                                    .map((DocumentSnapshot awardDocSnaps) {
                                  return SizedBox(
                                    height: 30,
                                    width: 30,
                                    child:
                                        Image.network(awardDocSnaps['award']),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onDoubleTap: () {
                    if (Provider.of<Authentication>(context, listen: false)
                            .getIsAnon ==
                        false) {
                      Provider.of<PostFunctions>(context, listen: false)
                          .addLike(
                        userUid: documentSnapshot['useruid'],
                        context: context,
                        postID: documentSnapshot['postid'],
                        subDocId:
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId,
                      );
                    } else {
                      Provider.of<FeedHelpers>(context, listen: false)
                          .IsAnonBottomSheet(context);
                    }
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.46,
                    width: MediaQuery.of(context).size.width,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: documentSnapshot['imageslist'][index],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            height: 50,
                            width: 50,
                            child:
                                LoadingWidget(constantColors: constantColors),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                      itemCount:
                          (documentSnapshot['imageslist'] as List).length,
                      itemHeight: MediaQuery.of(context).size.height * 0.3,
                      itemWidth: MediaQuery.of(context).size.width,
                      layout: SwiperLayout.DEFAULT,
                      indicatorLayout: PageIndicatorLayout.SCALE,
                      pagination: SwiperPagination(
                        margin: EdgeInsets.all(10),
                        builder: DotSwiperPaginationBuilder(
                          color: constantColors.whiteColor.withOpacity(0.6),
                          activeColor:
                              constantColors.darkColor.withOpacity(0.6),
                          size: 15,
                          activeSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showLikes(
                                  context: context,
                                  postId: documentSnapshot['postid']);
                        },
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("posts")
                                .doc(documentSnapshot['postid'])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, likeSnap) {
                              return SizedBox(
                                width: 60,
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        likeSnap.data!.docs.any((element) =>
                                                element.id ==
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserId)
                                            ? EvaIcons.heart
                                            : EvaIcons.heartOutline,
                                        color: constantColors.redColor,
                                        size: 18,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          likeSnap.data!.docs.length.toString(),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showCommentsSheet(
                                  snapshot: documentSnapshot,
                                  context: context,
                                  postId: documentSnapshot['postid']);
                        },
                        child: SizedBox(
                          width: 60,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.comment,
                                  color: constantColors.blueColor,
                                  size: 16,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(documentSnapshot['postid'])
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, commentSnap) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        commentSnap.data!.docs.length
                                            .toString(),
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showRewards(
                                  context: context,
                                  postId: documentSnapshot['postid']);
                        },
                        child: SizedBox(
                          width: 60,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.award,
                                  color: constantColors.yellowColor,
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("posts")
                                        .doc(documentSnapshot['postid'])
                                        .collection('awards')
                                        .snapshots(),
                                    builder: (context, awardSnap) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          awardSnap.data!.docs.length
                                              .toString(),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserId ==
                              documentSnapshot['useruid']
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context: context,
                                        postId: documentSnapshot['postid']);

                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .getImageDescription(
                                        documentSnapshot['description']);
                              },
                              icon: Icon(EvaIcons.moreVertical,
                                  color: constantColors.whiteColor),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 5,
                ),
                child: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    documentSnapshot['description'],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
