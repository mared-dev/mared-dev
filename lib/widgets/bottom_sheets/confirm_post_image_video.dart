import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/services/firebase/firebase_file_upload_service.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/utils/productUploadCameraScreen.dart';
import 'package:mared_social/utils/productUploadScreen.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/select_avatar_options_sheet.dart';
import 'package:mared_social/widgets/reusable/bottom_sheet_top_divider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

confirmPostImageVideo({
  required BuildContext context,
  required List<XFile> imageFiles,
}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            child: Column(
              children: [
                BottomSheetTopDivider(),
                Container(
                  width: 250.w,
                  height: 200.h,
                  child: imageFiles.length == 1
                      ? Image.file(
                          File(imageFiles[0].path),
                          fit: BoxFit.contain,
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            height: MediaQuery.of(context).size.height,
                            viewportFraction: 2.0,
                            enlargeCenterPage: false,
                          ),
                          items: imageFiles.map((e) {
                            return Image.file(
                              File(e.path),
                            );
                          }).toList(),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                  ),
                  child: _optionButton(
                    buttonText: "Confirm Image",
                    callback: () async {
                      print('image picked!!!');
                      LoadingHelper.startLoading();

                      List<String> imagesList = await FirebaseFileUploadService
                          .uploadMultipleImagesToFirebase(
                              multipleImages: imageFiles);

                      LoadingHelper.endLoading();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      Navigator.push(
                          context,
                          PageTransition(
                              child: PostUploadScreen(
                                multipleImages: imageFiles,
                                imagesList: imagesList,
                              ),
                              type: PageTransitionType.bottomToTop));
                    },
                  ),
                ),
                Container(
                  height: 32.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    ),
                    child: Text("Reselect",
                        textAlign: TextAlign.center,
                        style: regularTextStyle(
                            fontSize: 11,
                            textColor: AppColors.backGroundColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            height: 450.h,
            width: 1.sw,
            decoration: BoxDecoration(
                color: AppColors.commentButtonColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6), topLeft: Radius.circular(6))),
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
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        primary: AppColors.accentColor),
    child: Text(
      buttonText,
      style: regularTextStyle(fontSize: 11, textColor: Colors.black),
    ),
  );
}
