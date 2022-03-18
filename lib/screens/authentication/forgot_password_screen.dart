import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/general_styles.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/select_avatar_options_sheet.dart';
import 'package:mared_social/widgets/bottom_sheets/confirm_profile_pic_sheet.dart';
import 'package:mared_social/widgets/items/pick_image_avatar.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_group.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_item.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backGroundColor,
        body: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 120.h, bottom: 50.h),
                child:
                    SvgPicture.asset('assets/images/forgot_password_lock.svg'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create Account',
                      style: regularTextStyle(
                          fontSize: 20.sp,
                          textColor: AppColors.darkGrayTextColor),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        "Enter your email address below.We'll look for your account and send you a password reset email.",
                        style: regularTextStyle(
                            fontSize: 14.sp,
                            textColor: AppColors.darkGrayTextColor),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      decoration: getAuthInputDecoration(
                        hintText: 'Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    SizedBox(
                      width: screenSize.width,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 22.w, vertical: 14.h),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            primary: AppColors.widgetsBackground),
                        child: Text("SEND PASSWORD RESET"),
                      ),
                    ),
                    SizedBox(
                      height: 68.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
