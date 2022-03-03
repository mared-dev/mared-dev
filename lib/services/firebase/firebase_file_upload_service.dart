import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/helpers/compress_image_helper.dart';
import 'package:mared_social/utils/pick_files_helper.dart';

class FirebaseFileUploadService {
  static late UploadTask imagePostUploadTask;
  static Future uploadStoryVideo(
      {required BuildContext context, XFile? video}) async {
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
    videoUrl = await videoRef.getDownloadURL();

    return videoUrl;
  }

  static Future uploadPostVideo(
      {required BuildContext context, XFile? video}) async {
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
    videoUrl = await videoRef.getDownloadURL();

    return videoUrl;
  }

  static Future<List<String>> uploadMultipleImagesToFirebase(
      {required List<XFile> multipleImages}) async {
    //there should be some check when the list returned is empty
    List<String> imagesList = [];

    for (var i = 0; i < multipleImages.length; i++) {
      Reference imageReference = FirebaseStorage.instance
          .ref()
          .child('posts/${multipleImages[i].path}/${TimeOfDay.now()}');

      File compressedImage = await CompressImageHelper.compressImageAndGetFile(
          File(multipleImages[i].path));

      imagePostUploadTask = imageReference.putFile(File(compressedImage.path));
      await imagePostUploadTask.whenComplete(() {
        print("Post image uploaded to storage");
      });
      await imageReference.getDownloadURL().then((imageUrl) {
        imagesList.add(imageUrl);
      });
    }

    return imagesList;
  }

  static Future<String> uploadPostCameraImageToFirebase(
      File uploadPostImage) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');

    ///compressing step
    File compressedImage = await CompressImageHelper.compressImageAndGetFile(
        File(uploadPostImage.path));

    imagePostUploadTask = imageReference.putFile(compressedImage);
    await imagePostUploadTask.whenComplete(() {
      print("Post image uploaded to storage");
    });
    String uploadPostImageUrl = "";
    await imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    return uploadPostImageUrl;
  }

  // //to pick and show the post with camera image
  // Future pickUploadPostImage(BuildContext context, ImageSource source) async {
  //   final uploadPostImageVal = await PickFilesHelper.pickImage(source: source);
  //   uploadPostImageVal == null
  //   // ignore: avoid_print
  //       ? print("select image")
  //       : uploadPostImage = File(uploadPostImageVal.path);
  //   // ignore: avoid_print
  //   print(uploadPostImage.path);
  //
  //   // ignore: unnecessary_null_comparison
  //   uploadPostImage != null
  //       ? showPostCameraImage(context)
  //       : print("Image upload error");
  //
  //   notifyListeners();
  // }
}
