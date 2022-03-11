import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/fcm_notification_Service.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:nanoid/async.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

//move later to constants file
final FCMNotificationService _fcmNotificationService = FCMNotificationService();

TextEditingController commentController = TextEditingController();

showCommentsSheet({
  required BuildContext context,
  required snapshot,
  required String postId,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return CommentsSection(postId: postId, snapshot: snapshot);
    },
  );
}

class CommentsSection extends StatefulWidget {
  final postId;
  final snapshot;

  const CommentsSection(
      {Key? key, required this.postId, required this.snapshot})
      : super(key: key);
  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.whiteColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    "Comments",
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: widget.snapshot['comments']
                        .map<Widget>((dynamic commentDocSnap) {
                      return Container(
                        color: constantColors.blueGreyColor,
                        height: MediaQuery.of(context).size.height * 0.135,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (commentDocSnap['useruid'] !=
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserId) {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: AltProfile(
                                                  userUid:
                                                      commentDocSnap['useruid'],
                                                ),
                                                type: PageTransitionType
                                                    .bottomToTop));
                                      }
                                    },
                                    child: Container(
                                      // color: constantColors.darkColor,
                                      height: 30,
                                      width: 30,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: commentDocSnap['userimage'],
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
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            commentDocSnap['username'],
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(FontAwesomeIcons.arrowUp,
                                          size: 14,
                                          color: constantColors.blueColor),
                                    ),
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(FontAwesomeIcons.reply,
                                          size: 14,
                                          color: constantColors.yellowColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: constantColors.blueColor,
                                      size: 14,
                                    ),
                                    onPressed: () {},
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Text(
                                      commentDocSnap['comment'],
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserId ==
                                          commentDocSnap['useruid']
                                      ? IconButton(
                                          onPressed: () {
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .deleteUserComment(
                                                    postId: widget.postId,
                                                    commentId: commentDocSnap[
                                                        'commentid']);
                                          },
                                          icon: Icon(FontAwesomeIcons.trashAlt,
                                              size: 14,
                                              color: constantColors.redColor),
                                        )
                                      : const SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                ],
                              ),
                            ),
                            Divider(
                              color: constantColors.darkColor.withOpacity(0.2),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 300,
                      height: 30,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Add your opnion...',
                          hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controller: commentController,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: constantColors.greenColor,
                      child: Icon(
                        FontAwesomeIcons.comment,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        if (Provider.of<Authentication>(context, listen: false)
                                .getIsAnon ==
                            false) {
                          addComment(
                                  userUid: widget.snapshot['useruid'],
                                  postId: widget.snapshot['postid'],
                                  comment: commentController.text,
                                  context: context)
                              .whenComplete(() {
                            commentController.clear();
                          });
                        } else {
                          IsAnonBottomSheet(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

//TODO:move this later to firestore stuff file
Future addComment({
  required String userUid,
  required String postId,
  required String comment,
  required BuildContext context,
}) async {
  String commentId = nanoid(14).toString();

  var post =
      await FirebaseFirestore.instance.collection('posts').doc(postId).get();

  ///change this somewhere else
  UserModel userModel = UserInfoManger.getUserInfo();
  //add comment to posts collection
  await FirebaseFirestore.instance.collection('posts').doc(postId).update({
    'comments': [
      ...post.data()!['comments'],
      {
        'commentid': commentId,
        'comment': comment,
        'username': userModel.userName,
        'useruid': userModel.uid,
        'userimage': userModel.photoUrl,
        'useremail': userModel.email,
        'time': Timestamp.now(),
      }
    ]
  });

  //add comment to comments collection in posts in users
  await FirebaseFirestore.instance
      .collection("users")
      .doc(userUid)
      .collection('posts')
      .doc(postId)
      .update({
    'comments': [
      ...post.data()!['comments'],
      {
        'commentid': commentId,
        'comment': comment,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserId,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
        'useremail': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserEmail,
        'time': Timestamp.now(),
      }
    ]
  });

  await FirebaseFirestore.instance
      .collection("users")
      .doc(userUid)
      .get()
      .then((postUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((commentingUser) async {
      await _fcmNotificationService.sendNotificationToUser(
          to: postUser['fcmToken']!, //To change once set up
          title: "${commentingUser['username']} commented",
          body: comment);
    });
  });
}
