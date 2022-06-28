import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/helpers/time_helpers.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/feed_models/post_details_model.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/Profile/profile.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';
import 'package:mared_social/widgets/items/post_share_part.dart';
import 'package:mared_social/widgets/items/video_post_item.dart';
import 'package:mared_social/widgets/reusable/feed_item_body_with_like.dart';
import 'package:mared_social/widgets/reusable/feed_post_item_body.dart';
import 'package:mared_social/widgets/reusable/paginate_firestore_edited.dart';
import 'package:mared_social/widgets/reusable/post_comments_part.dart';
import 'package:mared_social/widgets/reusable/post_item_image.dart';
import 'package:mared_social/widgets/reusable/post_likes_part.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class FeedPostItem extends StatefulWidget {
  final documentSnapshot;
  final bool isInPostDetails;

  const FeedPostItem(
      {Key? key, required this.documentSnapshot, required this.isInPostDetails})
      : super(key: key);

  @override
  State<FeedPostItem> createState() => _FeedPostItemState();
}

class _FeedPostItemState extends State<FeedPostItem> {
  List<String> _editPostOptions = [];
  bool firstBuild = true;
  bool shouldShowPost = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editPostOptions =
        widget.isInPostDetails ? ['Edit post'] : ['Edit post', 'Delete post'];
  }

  @override
  Widget build(BuildContext context) {
    return !shouldShowPost
        ? Container()
        : Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 30.h),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(widget.documentSnapshot['postid'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!firstBuild &&
                        snapshot.hasData &&
                        snapshot.data != null) {
                      return _postContent(snapshot.data);
                    } else {
                      firstBuild = false;
                      return _postContent(widget.documentSnapshot);
                    }
                  },
                )));
  }

  Widget _postContent(documentSnapshotToUse) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (documentSnapshotToUse['useruid'] !=
                      UserInfoManger.getUserId()) {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: AltProfile(
                              userModel: UserModel(
                                  phoneNumber:
                                      GeneralFirebaseHelpers.getStringSafely(
                                          key: 'usercontactnumber',
                                          doc: documentSnapshotToUse),
                                  websiteLink:
                                      GeneralFirebaseHelpers.getStringSafely(
                                          key: 'websiteLink',
                                          doc: documentSnapshotToUse),
                                  bio: GeneralFirebaseHelpers.getStringSafely(
                                      key: 'bio', doc: documentSnapshotToUse),
                                  uid: documentSnapshotToUse['useruid'],
                                  userName: documentSnapshotToUse['username'],
                                  photoUrl:
                                      widget.documentSnapshot['userimage'],
                                  email: widget.documentSnapshot['useremail'],
                                  fcmToken: "",

                                  ///later you have to give this the right value
                                  store: false),
                              userUid: documentSnapshotToUse['useruid'],
                            ),
                            type: PageTransitionType.rightToLeft));
                  } else {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Profile(),
                            type: PageTransitionType.rightToLeft));
                  }
                },
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: documentSnapshotToUse['userimage'],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              LoadingWidget(constantColors: constantColors),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _postHeader(
                          userName: documentSnapshotToUse['username'],
                          address: documentSnapshotToUse['address'],
                          userId: documentSnapshotToUse['useruid'],
                          documentSnapshotToUse: documentSnapshotToUse),
                    ),
                    UserInfoManger.getUserId() ==
                            documentSnapshotToUse['useruid']
                        ? _editPostSection(documentSnapshotToUse)
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
        FeedItemBodyWithLike(
          imageList: documentSnapshotToUse['imageslist'],
          userId: documentSnapshotToUse['useruid'],
          postId: documentSnapshotToUse['postid'],
          likes: documentSnapshotToUse['likes'],
          videoThumbnail: documentSnapshotToUse['thumbnail'],
        ),
        _postFooter(documentSnapshot: documentSnapshotToUse),
        Padding(
          padding: EdgeInsets.only(
            left: 18.w,
          ),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  documentSnapshotToUse['caption'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: semiBoldTextStyle(
                    textColor: AppColors.commentButtonColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ReadMoreText(
                  documentSnapshotToUse['description'],
                  textAlign: TextAlign.start,
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  style: regularTextStyle(
                    textColor: AppColors.commentButtonColor,
                    fontSize: 11.sp,
                  ),
                  lessStyle: regularTextStyle(
                      textColor: Colors.black26, fontSize: 11.sp),
                  moreStyle: regularTextStyle(
                      textColor: Colors.black26, fontSize: 11.sp),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    TimeHelper.getElpasedTime(documentSnapshotToUse['time']),
                    textAlign: TextAlign.start,
                    style: lightTextStyle(
                        textColor: AppColors.accentColor, fontSize: 11.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _editPostSection(documentSnapshotToUse) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton:
            Icon(EvaIcons.moreVertical, color: AppColors.commentButtonColor),
        customItemsHeight: 8,
        items: [
          ..._editPostOptions.map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          ),
        ],
        onChanged: (String? value) {
          if (value == _editPostOptions[0]) {
            // Provider.of<PostFunctions>(context, listen: false).showPostOptions(
            //     context: context, postId: documentSnapshotToUse['postid']);

            Provider.of<PostFunctions>(context, listen: false).editCaptionText(
                context,
                PostDetailsModel.fromjson(documentSnapshotToUse),
                documentSnapshotToUse['postid']);
          } else if (value == _editPostOptions[1]) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.warning,
              confirmBtnText: "Delete",
              cancelBtnText: "Keep Post",
              showCancelBtn: true,
              title: "Delete this post?",
              onConfirmBtnTap: () async {
                Navigator.of(context, rootNavigator: true).pop();

                setState(() {
                  shouldShowPost = false;
                });
                LoadingHelper.startLoading();
                await Provider.of<FirebaseOperations>(context, listen: false)
                    .deletePostData(
                  userUid: documentSnapshotToUse['useruid'],
                  postId: documentSnapshotToUse['postid'],
                )
                    .then((value) {
                  LoadingHelper.endLoading();
                  Navigator.of(context, rootNavigator: true)
                      .pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomePage()),
                    (Route<dynamic> route) => false,
                  )
                      .onError((error, stackTrace) {
                    LoadingHelper.endLoading();
                  });
                });
              },
              onCancelBtnTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            );
          }
          // MenuItems.onChanged(context, value as MenuItem);
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }

  Widget _postFooter({
    required documentSnapshot,
  }) {
    return Container(
      height: 38.h,
      margin: EdgeInsets.only(left: 10.w, top: 8.h, bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PostLikesPart(
            postId: documentSnapshot['postid'],
            likes: documentSnapshot['likes'],
            userId: documentSnapshot['useruid'],
          ),
          PostCommentsPart(documentSnapshot: documentSnapshot),
          PostSharePart(postId: documentSnapshot['postid']),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _postHeader(
      {required String userName,
      required String address,
      required userId,
      required documentSnapshotToUse}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  if (userId != UserInfoManger.getUserId()) {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: AltProfile(
                              userModel: UserModel(
                                  phoneNumber:
                                      GeneralFirebaseHelpers.getStringSafely(
                                          key: 'usercontactnumber',
                                          doc: documentSnapshotToUse),
                                  websiteLink:
                                      GeneralFirebaseHelpers.getStringSafely(
                                          key: 'websiteLink',
                                          doc: documentSnapshotToUse),
                                  bio: GeneralFirebaseHelpers.getStringSafely(
                                      key: 'bio', doc: documentSnapshotToUse),
                                  uid: documentSnapshotToUse['useruid'],
                                  userName: documentSnapshotToUse['username'],
                                  photoUrl: documentSnapshotToUse['userimage'],
                                  email: documentSnapshotToUse['useremail'],
                                  fcmToken: "",

                                  ///later you have to give this the right value
                                  store: false),
                              userUid: userId,
                            ),
                            type: PageTransitionType.rightToLeft));
                  } else {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Profile(),
                            type: PageTransitionType.rightToLeft));
                  }
                },
                child: Text(userName,
                    style: semiBoldTextStyle(
                        fontSize: 15.sp, textColor: AppColors.accentColor))),
            if (address.isNotEmpty)
              SizedBox(
                height: 5.h,
              ),
            if (address.isNotEmpty)
              Text(
                address,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: lightTextStyle(fontSize: 11.sp, textColor: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
