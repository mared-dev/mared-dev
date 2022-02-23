import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/productUploadCameraScreen.dart';
import 'package:mared_social/utils/productUploadScreen.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_place_picker_mb/providers/place_provider.dart';
import 'package:google_maps_place_picker_mb/providers/search_provider.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late File uploadPostImage;
  late String uploadPostImageUrl;

  List<String> imagesList = [];
  List<XFile> multipleImages = [];

  File get getUploadPostImage => uploadPostImage;
  String get getUploadPostImageUrl => uploadPostImageUrl;

  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  Future<List<XFile>> multiImagePicker() async {
    List<XFile>? _images = await picker.pickMultiImage();
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        // ignore: avoid_print
        ? print("select image")
        : uploadPostImage = File(uploadPostImageVal.path);
    // ignore: avoid_print
    print(uploadPostImage.path);

    // ignore: unnecessary_null_comparison
    uploadPostImage != null
        ? showPostCameraImage(context)
        : print("Image upload error");

    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        multipleImages = await multiImagePicker();
                        if (multipleImages.isNotEmpty) {
                          showPostImage(context);
                        }
                        // pickUploadPostImage(
                        //   context,
                        //   ImageSource.gallery,
                        // );
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        "Camera",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        pickUploadPostImage(
                          context,
                          ImageSource.camera,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        height: MediaQuery.of(context).size.height,
                        viewportFraction: 2.0,
                        enlargeCenterPage: false,
                      ),
                      items: multipleImages.map((e) {
                        return Image.file(
                          File(e.path),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        child: Text(
                          "Reselect",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor,
                          ),
                        ),
                        onPressed: () {
                          selectPostImageType(context);
                        },
                      ),
                      MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Confirm Image",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          await uploadPostImageToFirebase();

                          Navigator.push(
                              context,
                              PageTransition(
                                  child: PostUploadScreen(
                                    multipleImages: multipleImages,
                                    imagesList: imagesList,
                                  ),
                                  type: PageTransitionType.bottomToTop));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showPostCameraImage(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.file(
                      uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        child: Text(
                          "Reselect",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor,
                          ),
                        ),
                        onPressed: () {
                          selectPostImageType(context);
                        },
                      ),
                      MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Confirm Image",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          await uploadPostCameraImageToFirebase();

                          Navigator.push(
                              context,
                              PageTransition(
                                  child: PostUploadCameraScreen(
                                    uploadPostImage: uploadPostImage,
                                    uploadPostImageUrl: uploadPostImageUrl,
                                  ),
                                  type: PageTransitionType.bottomToTop));
                          // editPostCameraSheet(context);
                          // print("image uploaded");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future uploadPostImageToFirebase() async {
    multipleImages.forEach((element) async {
      Reference imageReference = FirebaseStorage.instance
          .ref()
          .child('posts/${element.path}/${TimeOfDay.now()}');

      imagePostUploadTask = imageReference.putFile(File(element.path));
      await imagePostUploadTask.whenComplete(() {
        print("Post image uploaded to storage");
      });
      await imageReference.getDownloadURL().then((imageUrl) {
        imagesList.add(imageUrl);
      });
      notifyListeners();
    });
  }

  Future uploadPostCameraImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');

    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print("Post image uploaded to storage");
    });
    await imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }
}
