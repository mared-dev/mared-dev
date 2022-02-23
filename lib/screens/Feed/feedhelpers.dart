import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/screens/Stories/stories.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/screens/searchPage/searchPage.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      leading: const SizedBox(
        height: 0,
        width: 0,
      ),
      backgroundColor: constantColors.darkColor.withOpacity(0.8),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            if (Provider.of<Authentication>(context, listen: false).getIsAnon ==
                false) {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            } else {
              IsAnonBottomSheet(context);
            }
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constantColors.greenColor,
          ),
        ),
      ],
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
              text: "Feed",
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

  Widget feedBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: MediaQuery.of(context).size.height * 0.42,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: constantColors.blueGreyColor,
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      PageTransition(
                        child: SearchPage(),
                        type: PageTransitionType.rightToLeft,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: MediaQuery.of(context).size.height * 0.065,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: constantColors.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: constantColors.greenColor,
                              width: 1,
                            )),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.search_outlined,
                                size: 25,
                                color: constantColors.darkColor,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Looking for something?",
                                style: TextStyle(
                                  color:
                                      constantColors.darkColor.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, stateSet) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("banners")
                            .where("enddate",
                                isGreaterThan:
                                    Timestamp.fromDate(DateTime.now()))
                            .snapshots(),
                        builder: (context, bannerSnap) {
                          if (bannerSnap.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingWidget(
                                constantColors: constantColors);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color:
                                      constantColors.darkColor.withOpacity(0.5),
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
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: bannerSnap.data!
                                                  .docs[index]['imageslist'][0],
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                      downloadProgress) {
                                                return LoadingWidget(
                                                    constantColors:
                                                        constantColors);
                                              },
                                              errorWidget:
                                                  (context, url, error) =>
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
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("posts")
                                                        .doc(bannerSnap.data!
                                                                .docs[index]
                                                            ['postid'])
                                                        .get()
                                                        .then((value) {
                                                      Provider.of<AltProfileHelper>(
                                                              context,
                                                              listen: false)
                                                          .showPostDetail(
                                                              context: context,
                                                              documentSnapshot:
                                                                  value);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: constantColors
                                                          .blueColor
                                                          .withOpacity(0.9),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Text(
                                                      "View Post",
                                                      style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
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
                                                visible: bannerSnap
                                                            .data!.docs[index]
                                                        ['useruid'] !=
                                                    Provider.of<Authentication>(
                                                            context,
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
                                                                        .data!
                                                                        .docs[index]
                                                                    ['useruid'],
                                                              ),
                                                              type: PageTransitionType
                                                                  .bottomToTop));
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: constantColors
                                                            .greenColor
                                                            .withOpacity(0.9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Text(
                                                        "Visit Profile",
                                                        style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
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
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 3.0, left: 3, bottom: 3, top: 3),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4.0,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Mared Moments",
                              style: TextStyle(
                                color: constantColors.blueColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: constantColors.darkColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("stories")
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (context, storiesSnaps) {
                              if (storiesSnaps.data!.docs.length == 0) {
                                return Center(
                                  child: Text(
                                    "No Stories Yet",
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: storiesSnaps.data!.docs.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: Stories(
                                                querySnapshot: storiesSnaps,
                                                snapIndex: index,
                                              ),
                                              type: PageTransitionType
                                                  .bottomToTop),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 80,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: constantColors.blueColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: SizedBox(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: storiesSnaps
                                                            .data!.docs[index]
                                                        ['userimage'],
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        LoadingWidget(
                                                            constantColors:
                                                                constantColors),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                                height: 80,
                                                width: 80,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return SliverPadding(
              padding: const EdgeInsets.all(4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.toInt() < snapshot.data!.docs.length) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
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
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserId) {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: AltProfile(
                                                  userUid: documentSnapshot[
                                                      'useruid'],
                                                ),
                                                type: PageTransitionType
                                                    .bottomToTop));
                                      }
                                    },
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              documentSnapshot['userimage'],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              LoadingWidget(
                                                  constantColors:
                                                      constantColors),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                Text(
                                                  documentSnapshot['caption'],
                                                  style: TextStyle(
                                                    color: constantColors
                                                        .greenColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Text(
                                                    ", ${documentSnapshot['address']}",
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: constantColors
                                                          .lightColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            child: RichText(
                                              text: TextSpan(
                                                text: documentSnapshot[
                                                    'username'],
                                                style: TextStyle(
                                                  color:
                                                      constantColors.blueColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        " , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}",
                                                    style: TextStyle(
                                                      color: constantColors
                                                          .lightColor
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
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .showAwardsPresenter(
                                              context: context,
                                              postId:
                                                  documentSnapshot['postid']);
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.045,
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
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: awardSnaps.data!.docs
                                                  .map((DocumentSnapshot
                                                      awardDocSnaps) {
                                                return SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Image.network(
                                                      awardDocSnaps['award']),
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
                                  if (Provider.of<Authentication>(context,
                                              listen: false)
                                          .getIsAnon ==
                                      false) {
                                    Provider.of<PostFunctions>(context,
                                            listen: false)
                                        .addLike(
                                      userUid: documentSnapshot['useruid'],
                                      context: context,
                                      postID: documentSnapshot['postid'],
                                      subDocId: Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserId,
                                    );
                                  } else {
                                    IsAnonBottomSheet(context);
                                  }
                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.44,
                                  width: MediaQuery.of(context).size.width,
                                  child: Swiper(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: documentSnapshot['imageslist']
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
                                        (documentSnapshot['imageslist'] as List)
                                            .length,
                                    itemHeight:
                                        MediaQuery.of(context).size.height *
                                            0.3,
                                    itemWidth:
                                        MediaQuery.of(context).size.width,
                                    layout: SwiperLayout.DEFAULT,
                                    indicatorLayout: PageIndicatorLayout.SCALE,
                                    pagination: SwiperPagination(
                                      margin: EdgeInsets.all(10),
                                      builder: DotSwiperPaginationBuilder(
                                        color: constantColors.whiteColor
                                            .withOpacity(0.6),
                                        activeColor: constantColors.darkColor
                                            .withOpacity(0.6),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .showLikes(
                                                context: context,
                                                postId:
                                                    documentSnapshot['postid']);
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
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      likeSnap.data!.docs.any((element) =>
                                                              element.id ==
                                                              Provider.of<Authentication>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getUserId)
                                                          ? EvaIcons.heart
                                                          : EvaIcons
                                                              .heartOutline,
                                                      color: constantColors
                                                          .redColor,
                                                      size: 18,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        likeSnap
                                                            .data!.docs.length
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .showCommentsSheet(
                                                snapshot: documentSnapshot,
                                                context: context,
                                                postId:
                                                    documentSnapshot['postid']);
                                      },
                                      child: SizedBox(
                                        width: 60,
                                        height: 50,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.comment,
                                                color: constantColors.blueColor,
                                                size: 16,
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("posts")
                                                    .doc(documentSnapshot[
                                                        'postid'])
                                                    .collection('comments')
                                                    .snapshots(),
                                                builder:
                                                    (context, commentSnap) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      commentSnap
                                                          .data!.docs.length
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .showRewards(
                                                context: context,
                                                postId:
                                                    documentSnapshot['postid']);
                                      },
                                      child: SizedBox(
                                        width: 60,
                                        height: 50,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.award,
                                                color:
                                                    constantColors.yellowColor,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: StreamBuilder<
                                                    QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("posts")
                                                      .doc(documentSnapshot[
                                                          'postid'])
                                                      .collection('awards')
                                                      .snapshots(),
                                                  builder:
                                                      (context, awardSnap) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        awardSnap
                                                            .data!.docs.length
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                    Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserId ==
                                            documentSnapshot['useruid']
                                        ? IconButton(
                                            onPressed: () {
                                              Provider.of<PostFunctions>(
                                                      context,
                                                      listen: false)
                                                  .showPostOptions(
                                                      context: context,
                                                      postId: documentSnapshot[
                                                          'postid']);

                                              Provider.of<PostFunctions>(
                                                      context,
                                                      listen: false)
                                                  .getImageDescription(
                                                      documentSnapshot[
                                                          'description']);
                                            },
                                            icon: Icon(EvaIcons.moreVertical,
                                                color:
                                                    constantColors.whiteColor),
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
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  IsAnonBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: IsAnonMsg(),
          ),
        );
      },
    );
  }
}
