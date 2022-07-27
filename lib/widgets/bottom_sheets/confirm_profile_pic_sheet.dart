import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/select_avatar_options_sheet.dart';
import 'package:provider/provider.dart';

confirmProfilePicSheet(
    {required BuildContext context,
    required File imageFile,
    required setUploadedImageLinkCallback}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 14.h, bottom: 28.h),
                  height: 5.h,
                  width: 135.w,
                  decoration: BoxDecoration(
                      color: AppColors.darkGrayTextColor,
                      borderRadius: BorderRadius.circular(3)),
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: AppColors.accentColor,
                  // backgroundImage: FileImage(
                  //   userAvatar,
                  // ),

                  child: CircleAvatar(
                    radius: 76,
                    backgroundImage: FileImage(imageFile),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 8.h),
                  child: _optionButton(
                    buttonText: "Confirm Image",
                    callback: () async {
                      print('image picked!!!');
                      LoadingHelper.startLoading();
                      String imageUrl = await Provider.of<FirebaseOperations>(
                              context,
                              listen: false)
                          .uploadUserAvatar(
                              context: context, pickedFile: imageFile);
                      setUploadedImageLinkCallback(imageUrl);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      LoadingHelper.endLoading();
                    },
                  ),
                ),
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            height: 0.5.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      });
}

Widget _optionButton({buttonText, callback}) {
  return ElevatedButton(
    onPressed: callback,
    style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
