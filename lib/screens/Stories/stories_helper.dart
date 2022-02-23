import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/screens/Stories/stories_widget.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';

class StoriesHelper with ChangeNotifier {
  final picker = ImagePicker();
  late UploadTask imageUploadTask;
  late File storyImage;
  File get getStoryImage => storyImage;
  final StoryWidgets storyWidgets = StoryWidgets();
  late String storyImageUrl;
  String get getStoryImageUrl => storyImageUrl;

  Future selectStoryImage(
      {required BuildContext context, required ImageSource source}) async {
    final pickedStoryImage = await picker.pickImage(source: source);
    pickedStoryImage == null
        ? print("Error")
        : storyImage = File(pickedStoryImage.path);

    // ignore: unnecessary_null_comparison
    storyImage != null
        ? storyWidgets.previewStoryImage(
            context: context, storyImage: storyImage)
        : print("Error");

    notifyListeners();
  }

  Future uploadStoryImage({required BuildContext context}) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage.path}/${Timestamp.now()}');

    imageUploadTask = imageReference.putFile(getStoryImage);
    await imageUploadTask.whenComplete(() {});
    await imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print(storyImageUrl);
    });
    notifyListeners();
  }

  Iterable<int> range(int low, int high) sync* {
    for (int i = low; i < high; ++i) {
      yield i;
    }
  }

  Future addStoryToNewHighlight({
    required BuildContext context,
    required String userUid,
    required String highLightName,
    required String storyImage,
    required String storyId,
    required String highlightId,
  }) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .collection("highlights")
        .doc(highlightId)
        .set({
      'highlightid': highlightId,
      'title': highLightName,
      'cover': storyImage,
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection("highlights")
          .doc(highlightId)
          .collection("stories")
          .doc(storyId)
          .set({
        'storyid': storyId,
        'image': storyImage,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
        'useremail': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserEmail,
        'useruid': userUid,
        'time': Timestamp.now(),
      });
    });
  }
}
