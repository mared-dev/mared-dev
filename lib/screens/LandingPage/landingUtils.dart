import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:provider/provider.dart';

class LandingUtils with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final picker = ImagePicker();
  late File userAvatar;
  late String userAvatarUrl;

  File get getUserAvatar => userAvatar;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickedUserAvatar == null
        // ignore: avoid_print
        ? print("select image")
        : userAvatar = File(pickedUserAvatar.path);
    // ignore: avoid_print
    print(userAvatar.path);

    // ignore: unnecessary_null_comparison
    userAvatar != null
        ? Provider.of<LandingService>(context, listen: false)
            .showUserAvatar(context)
        : print("Image upload error");

    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            bottom: true,
            child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Select Profile Picture",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            pickUserAvatar(context, ImageSource.gallery)
                                .whenComplete(() {
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .showUserAvatar(context);
                            });
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Camera',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            pickUserAvatar(context, ImageSource.camera)
                                .whenComplete(() {
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .showUserAvatar(context);
                            });
                          }),
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        });
  }
}
