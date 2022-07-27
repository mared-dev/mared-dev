import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';
import 'package:mared_social/widgets/items/video_post_item.dart';
import 'package:mared_social/widgets/reusable/post_comments_part.dart';
import 'package:mared_social/widgets/reusable/post_likes_part.dart';
import 'package:provider/provider.dart';

showPostDetail(
    {required BuildContext context,
    required DocumentSnapshot documentSnapshot}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return PostDetails(
        documentSnapshot: documentSnapshot,
      );
    },
  );
}

class PostDetails extends StatefulWidget {
  final dynamic documentSnapshot;

  const PostDetails({Key? key, this.documentSnapshot}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Divider(
                thickness: 4,
                color: constantColors.whiteColor,
              ),
            ),
            InkWell(
              onDoubleTap: () {
                if (UserInfoManger.isNotGuest()) {
                  Provider.of<PostFunctions>(context, listen: false).addLike(
                    userUid: widget.documentSnapshot['useruid'],
                    context: context,
                    postID: widget.documentSnapshot['postid'],
                    subDocId:
                        Provider.of<Authentication>(context, listen: false)
                            .getUserId,
                  );
                } else {
                  IsAnonBottomSheet(context);
                }
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: PostHelpers.checkIfPostIsVideo(
                        widget.documentSnapshot['imageslist'])
                    ? VideoPostItem(
                        userId: widget.documentSnapshot['useruid'],
                        videoUrl: widget.documentSnapshot['imageslist'][0],
                        videoThumbnailLink:
                            widget.documentSnapshot['thumbnail'],
                      )
                    : Swiper(
                        loop: false,
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: widget.documentSnapshot['imageslist']
                                [index],
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
                            (widget.documentSnapshot['imageslist'] as List)
                                .length,
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
            Text(
              widget.documentSnapshot['description'],
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PostLikesPart(
                        postId: widget.documentSnapshot['postid'],
                        likes: widget.documentSnapshot['likes'],
                        userId: widget.documentSnapshot['useruid'],
                      ),
                      InkWell(
                          onTap: () {
                            showCommentsSheet(
                                snapshot: widget.documentSnapshot,
                                context: context,
                                postId: widget.documentSnapshot['postid']);
                          },
                          child: PostCommentsPart(
                            documentSnapshot: widget.documentSnapshot,
                          )),
                      const Spacer(),

                      ///change here if you want the posts to be deleted by anyone
                      UserInfoManger.getUserId() ==
                              widget.documentSnapshot['useruid']
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context: context,
                                        postId:
                                            widget.documentSnapshot['postid']);

                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .getImageDescription(
                                        widget.documentSnapshot['description']);
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
            ),
          ],
        ),
      ),
    );
  }
}
