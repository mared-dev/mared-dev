import 'package:cloud_firestore/cloud_firestore.dart';

import '../../helpers/firebase_general_helpers.dart';

class PostDetailsModel {
  String userName;
  final String userImage;
  final String userEmail;
  final List imageList;
  final String userId;
  final String postId;
  final List likes;
  final String thumbnail;
  final String caption;
  final String description;
  final Timestamp time;
  final String websiteLink;
  final String bio;
  final String address;
  final List comments;

  PostDetailsModel(
      {required this.userName,
      required this.address,
      required this.userImage,
      required this.userEmail,
      required this.imageList,
      required this.userId,
      required this.postId,
      required this.likes,
      required this.comments,
      required this.thumbnail,
      required this.caption,
      required this.description,
      required this.time,
      required this.websiteLink,
      required this.bio});

  PostDetailsModel.fromjson(documentSnapshotToUse)
      : imageList = documentSnapshotToUse['imageslist'],
        userId = documentSnapshotToUse['useruid'],
        postId = documentSnapshotToUse['postid'],
        likes = documentSnapshotToUse['likes'],
        comments = documentSnapshotToUse['comments'],
        thumbnail = documentSnapshotToUse['thumbnail'],
        caption = documentSnapshotToUse['caption'],
        description = documentSnapshotToUse['description'],
        time = documentSnapshotToUse['time'],
        websiteLink = GeneralFirebaseHelpers.getStringSafely(
            key: 'websiteLink', doc: documentSnapshotToUse),
        bio = GeneralFirebaseHelpers.getStringSafely(
            key: 'bio', doc: documentSnapshotToUse),
        userName = documentSnapshotToUse['username'],
        userImage = documentSnapshotToUse['userimage'],
        address = documentSnapshotToUse['address'],
        userEmail = documentSnapshotToUse['useremail'];
}
