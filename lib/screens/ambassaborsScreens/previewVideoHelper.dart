import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PreviewVideoHelper with ChangeNotifier {
  late UploadTask imagePostUploadTask;

  late String _uploadPostImageUrl;

  late UploadTask videoUploadTask;
  late String _videoUrl;

  Future uploadStoryVideo(
      {required BuildContext context, required File videoFile}) async {
    Reference videoRef = FirebaseStorage.instance
        .ref()
        .child('stories/${videoFile.path}/${Timestamp.now()}');

    videoUploadTask = videoRef.putFile(
        File(videoFile.path), SettableMetadata(contentType: 'video/mp4'));

    await videoUploadTask.whenComplete(() {
      print("video uploaded");
    });
    await videoRef.getDownloadURL().then((url) {
      _videoUrl = url;
    });
    notifyListeners();
  }

  Future uploadPostCameraImageToFirebase(
      {required File uploadPostImage}) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');

    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print("Post image uploaded to storage");
    });
    imageReference.getDownloadURL().then((imageUrl) {
      _uploadPostImageUrl = imageUrl;
    });
    notifyListeners();
  }
}
