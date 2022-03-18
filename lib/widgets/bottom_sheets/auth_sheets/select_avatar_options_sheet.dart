import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/utils/pick_files_helper.dart';
import 'package:mared_social/widgets/bottom_sheets/confirm_profile_pic_sheet.dart';
import 'package:provider/provider.dart';

late File userAvatar;
Future selectAvatarOptionsSheet(
    {required BuildContext context, required setSelectedFileCallback}) async {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 14.h, bottom: 16.h),
                  height: 5.h,
                  width: 135.w,
                  decoration: BoxDecoration(
                      color: AppColors.darkGrayTextColor,
                      borderRadius: BorderRadius.circular(3)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Select Profile Picture",
                        style: lightTextStyle(
                            fontSize: 18, textColor: Colors.white)),
                  ],
                ),
                SizedBox(
                  height: 17.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _optionButton(
                        context: context,
                        buttonText: 'Gallery',
                        callback: () async {
                          XFile pickedFile = await _pickUserAvatar(
                              context, ImageSource.gallery);
                          print('@@@@@@@@@@@@@@@@@');
                          print(pickedFile.path);
                          // confirmProfilePicSheet(
                          //     context, File(pickedFile.path));
                          // confirmProfilePicSheet(
                          //   context,
                          // );
                          setSelectedFileCallback(File(pickedFile.path));
                        }),
                    _optionButton(
                        context: context,
                        buttonText: 'Camera',
                        callback: () async {
                          XFile pickedFile = await _pickUserAvatar(
                              context, ImageSource.camera);

                          // confirmProfilePicSheet(
                          //     context, File(pickedFile.path));
                          // confirmProfilePicSheet(
                          //   context,
                          // );
                          setSelectedFileCallback(File(pickedFile.path));
                        }),
                  ],
                )
              ],
            ),
            height: 0.2.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      });
}

Widget _optionButton({context, buttonText, callback}) {
  return ElevatedButton(
    onPressed: callback,
    style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        primary: AppColors.accentColor),
    child: Text(
      buttonText,
      style: regularTextStyle(fontSize: 11, textColor: Colors.black),
    ),
  );
}

Future _pickUserAvatar(BuildContext context, ImageSource source) async {
  final pickedUserAvatar = await PickFilesHelper.pickImage(source: source);
  pickedUserAvatar == null
      // ignore: avoid_print
      ? print("select image")
      : userAvatar = File(pickedUserAvatar.path);

  return pickedUserAvatar;
}
