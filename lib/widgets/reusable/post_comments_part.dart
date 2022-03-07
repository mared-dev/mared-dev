import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';

class PostCommentsPart extends StatelessWidget {
  final documentSnapshot;

  const PostCommentsPart({Key? key, required this.documentSnapshot})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Start HERE
        showCommentsSheet(
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  documentSnapshot['comments'].length.toString(),
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
      ),
    );
  }
}
