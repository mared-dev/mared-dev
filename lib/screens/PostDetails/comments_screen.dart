import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';
import 'package:mared_social/widgets/reusable/interacted_user_item.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snapshot;
  final postId;

  const CommentsScreen({
    Key? key,
    this.snapshot,
    this.postId,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late TextEditingController commentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: simpleAppBarWithBack(context,
          title: 'Comments',
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: Column(
        children: [
          Expanded(
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                children: widget.snapshot['comments']
                    .map<Widget>((commentItem) => InteractedUserItem(
                        imageUrl: commentItem['userimage'],
                        title: commentItem['username'],
                        subtitle: commentItem['comment'],
                        trailingIcon: IconButton(
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .deleteUserComment(
                                    postId: widget.postId,
                                    commentId: commentItem['commentid']);
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/delete_comment_icon.svg',
                            width: 20,
                            height: 18,
                          ),
                        ),
                        leadingCallback: () {
                          if (commentItem['useruid'] !=
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userModel: UserModel(
                                          uid: commentItem['useruid'],
                                          userName: commentItem['username'],
                                          photoUrl: commentItem['userimage'],
                                          email: commentItem['useremail'],
                                          fcmToken: "",

                                          ///later you have to give this the right value
                                          store: false),
                                      userUid: commentItem['useruid'],
                                    ),
                                    type: PageTransitionType.bottomToTop));
                          }
                        }))
                    .toList()),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60.h, left: 28.w, right: 28.w),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (Provider.of<Authentication>(context, listen: false)
                              .getIsAnon ==
                          false) {
                        LoadingHelper.startLoading();
                        await addComment(
                            userUid: widget.snapshot['useruid'],
                            postId: widget.postId,
                            comment: commentController.text,
                            context: context);
                        commentController.clear();
                        LoadingHelper.endLoading();
                        Navigator.of(context).pop();
                      } else {
                        IsAnonBottomSheet(context);
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 16.w, top: 10.h, bottom: 10.h),
                      child: SvgPicture.asset(
                        'assets/icons/submit_comment_icon.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 21.w, vertical: 16.h),
                  filled: true,
                  hintStyle: regularTextStyle(
                      fontSize: 12, textColor: AppColors.commentButtonColor),
                  hintText: "Add your comments",
                  fillColor: Colors.white70),
            ),
          )
        ],
      ),
    );
  }
}
