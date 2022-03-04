import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/helpers/time_helpers.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/items/video_post_item.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';
import 'package:mared_social/widgets/reusable/post_item_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostsSection extends StatefulWidget {
  @override
  _PostsSectionState createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  @override
  Widget build(BuildContext context) {
    //temp changing StreamBuilder to FutureBuilder and .snapshot to .get
    return CustomPaginateFirestore(
      //item builder type is compulsory.

      itemBuilder: (context, snapshot, index) {
        dynamic documentSnapshot = snapshot[index].data()!;
        return Padding(
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
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
                        _postHeader(
                          userName: documentSnapshot['username'],
                          address: documentSnapshot['address'],
                        )
                      ],
                    ),
                  ),
                  _postBody(
                      imageList: documentSnapshot['imageslist'],
                      userId: documentSnapshot['useruid'],
                      postId: documentSnapshot['postid']),
                  ////TODO:this need to be optimized
                  // _postFooter(documentSnapshot: documentSnapshot),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 5,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            documentSnapshot['caption'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantColors.whiteColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            documentSnapshot['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              TimeHelper.getElpasedTime(
                                  documentSnapshot['time']),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color:
                                    constantColors.lightColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
      // orderBy is compulsory to enable pagination
      query: FirebaseFirestore.instance
          .collection("posts")
          .orderBy('time', descending: true),
      //Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
      // to fetch real-time data
      isLive: false,
    );
  }

  Widget _postFooter({
    required documentSnapshot,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Provider.of<PostFunctions>(context, listen: false).showLikes(
                    context: context, postId: documentSnapshot['postid']);
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
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId)
                                  ? EvaIcons.heart
                                  : EvaIcons.heartOutline,
                              color: constantColors.redColor,
                              size: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
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
                              commentSnap.data!.docs.length.toString(),
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
                Provider.of<PostFunctions>(context, listen: false).showRewards(
                    context: context, postId: documentSnapshot['postid']);
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
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 8.0),
                      //   child: StreamBuilder<QuerySnapshot>(
                      //     stream: FirebaseFirestore.instance
                      //         .collection("posts")
                      //         .doc(documentSnapshot[
                      //             'postid'])
                      //         .collection('awards')
                      //         .snapshots(),
                      //     builder: (context, awardSnap) {
                      //       return Padding(
                      //         padding:
                      //             const EdgeInsets.only(
                      //                 left: 8.0),
                      //         child: Text(
                      //           awardSnap.data!.docs.length
                      //               .toString(),
                      //           style: TextStyle(
                      //             color: constantColors
                      //                 .whiteColor,
                      //             fontWeight:
                      //                 FontWeight.bold,
                      //             fontSize: 14,
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Provider.of<Authentication>(context, listen: false).getUserId ==
                    documentSnapshot['useruid']
                ? IconButton(
                    onPressed: () {
                      Provider.of<PostFunctions>(context, listen: false)
                          .showPostOptions(
                              context: context,
                              postId: documentSnapshot['postid']);

                      Provider.of<PostFunctions>(context, listen: false)
                          .getImageDescription(documentSnapshot['description']);
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
    );
  }

  Widget _postBody({required userId, required postId, required imageList}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        onDoubleTap: () {
          if (Provider.of<Authentication>(context, listen: false).getIsAnon ==
              false) {
            Provider.of<PostFunctions>(context, listen: false).addLike(
              userUid: userId,
              context: context,
              postID: postId,
              subDocId:
                  Provider.of<Authentication>(context, listen: false).getUserId,
            );
          } else {
            IsAnonBottomSheet(context);
          }
        },
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.44,
            width: MediaQuery.of(context).size.width,
            child: !PostHelpers.checkIfPostIsVideo(imageList)
                ? Swiper(
                    key: UniqueKey(),
                    itemBuilder: (BuildContext context, int index) {
                      // return Image.network(
                      //   imageList[index],
                      //   key: UniqueKey(),
                      //   fit: BoxFit.cover,
                      // );

                      ///legacy code
                      return PostItemImage(
                        imageUrl: imageList[index],
                      );
                    },
                    itemCount: (imageList as List).length,
                    itemHeight: MediaQuery.of(context).size.height * 0.3,
                    itemWidth: MediaQuery.of(context).size.width,
                    layout: SwiperLayout.DEFAULT,
                    indicatorLayout: PageIndicatorLayout.SCALE,
                    pagination: SwiperPagination(
                      margin: EdgeInsets.all(10),
                      builder: DotSwiperPaginationBuilder(
                        color: constantColors.whiteColor.withOpacity(0.6),
                        activeColor: constantColors.darkColor.withOpacity(0.6),
                        size: 15,
                        activeSize: 15,
                      ),
                    ),
                  )
                : VideoPostItem(videoUrl: imageList[0])),
      ),
    );
  }

  Widget _postHeader({
    required String userName,
    required String address,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: RichText(
                text: TextSpan(
                  text: userName,
                  style: TextStyle(
                    color: constantColors.blueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  address,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: constantColors.lightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  //move to a seprate file later
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
