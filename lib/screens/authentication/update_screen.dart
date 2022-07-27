import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/update_screen_background.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Please update to the latest version',
                      style: regularTextStyle(
                          fontSize: 12,
                          textColor: AppColors.commentButtonColor),
                    ),
                    SizedBox(
                      height: 31.h,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (Platform.isIOS) {
                            launch(
                                'https://apps.apple.com/us/app/mared-connecting-business/id1547218031');
                          } else {
                            launch(
                                'https://play.google.com/store/apps/details?id=ke.co.rufw91.mared');
                          }
                        } catch (e) {
                          print(e);
                          print("couldn't launch URL");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.w, vertical: 11.h),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          primary: AppColors.navyColor),
                      child: Text('Update'),
                    ),
                    SizedBox(
                      height: 43.h,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
