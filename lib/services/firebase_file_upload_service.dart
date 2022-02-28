import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future uploadStoryVideo({required BuildContext context,XFile? video}) async {
  late UploadTask videoUploadTask;
  String videoUrl;


  Reference videoRef = FirebaseStorage.instance
      .ref()
      .child('stories/${video!.path}/${Timestamp.now()}');

  videoUploadTask = videoRef.putFile(
      File(video.path), SettableMetadata(contentType: 'video/mp4'));

  await videoUploadTask.whenComplete(() {
    print("video uploaded");
  });
  videoUrl=await videoRef.getDownloadURL();

  return videoUrl;
}

Future uploadPostVideo({required BuildContext context,XFile? video}) async {
  late UploadTask videoUploadTask;
  String videoUrl;


  Reference videoRef = FirebaseStorage.instance
      .ref()
      .child('posts/${video!.path}/${Timestamp.now()}');

  videoUploadTask = videoRef.putFile(
      File(video.path), SettableMetadata(contentType: 'video/mp4'));

  await videoUploadTask.whenComplete(() {
    print("video uploaded");
  });
  videoUrl=await videoRef.getDownloadURL();

  return videoUrl;
}