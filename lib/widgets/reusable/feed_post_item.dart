import 'package:flutter/material.dart';
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
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';
import 'package:mared_social/widgets/items/video_post_item.dart';
import 'package:mared_social/widgets/reusable/feed_post_item_body.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';
import 'package:mared_social/widgets/reusable/post_comments_part.dart';
import 'package:mared_social/widgets/reusable/post_item_image.dart';
import 'package:mared_social/widgets/reusable/post_likes_part.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedPostItem extends StatefulWidget {
  final documentSnapshot;

  const FeedPostItem({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  State<FeedPostItem> createState() => _FeedPostItemState();
}

class _FeedPostItemState extends State<FeedPostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
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
                        if (widget.documentSnapshot['useruid'] !=
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AltProfile(
                                    userUid: widget.documentSnapshot['useruid'],
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
                            imageUrl: widget.documentSnapshot['userimage'],
                            progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                LoadingWidget(constantColors: constantColors),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    _postHeader(
                        userName: widget.documentSnapshot['username'],
                        address: widget.documentSnapshot['address'],
                        userId: widget.documentSnapshot['useruid'])
                  ],
                ),
              ),
              FeedPostItemBody(
                imageList: widget.documentSnapshot['imageslist'],
                userId: widget.documentSnapshot['useruid'],
                postId: widget.documentSnapshot['postid'],
              ),
              ////TODO:this need to be optimized
              _postFooter(documentSnapshot: widget.documentSnapshot),
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
                        widget.documentSnapshot['caption'],
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
                        widget.documentSnapshot['description'],
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
                              widget.documentSnapshot['time']),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: constantColors.lightColor.withOpacity(0.8),
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
            PostLikesPart(
              postId: documentSnapshot['postid'],
              likes: documentSnapshot['likes'],
            ),
            PostCommentsPart(documentSnapshot: documentSnapshot),
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

  Widget _postHeader(
      {required String userName, required String address, required userId}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (userId !=
                    Provider.of<Authentication>(context, listen: false)
                        .getUserId) {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: AltProfile(
                            userUid: userId,
                          ),
                          type: PageTransitionType.bottomToTop));
                }
              },
              child: SizedBox(
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
