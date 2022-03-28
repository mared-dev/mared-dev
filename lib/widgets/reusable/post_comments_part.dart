import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/screens/PostDetails/comments_screen.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PostCommentsPart extends StatelessWidget {
  final documentSnapshot;

  const PostCommentsPart({Key? key, required this.documentSnapshot})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Start HERE
        // showCommentsSheet(
        //     snapshot: documentSnapshot,
        //     context: context,
        //     postId: documentSnapshot['postid']);
        pushNewScreen(
          context,
          screen: CommentsScreen(
            snapshot: documentSnapshot,
            postId: documentSnapshot['postid'],
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25.w,
            ),
            SvgPicture.asset(
              'assets/icons/post_comment_icon.svg',
              width: 18,
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('comment',
                  style: regularTextStyle(
                      fontSize: 11.sp,
                      textColor: AppColors.commentButtonColor)),
            ),
          ],
        ),
      ),
    );
  }
}
