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

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              SizedBox(
                height: 52.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.h),
                width: screenSize.width,
                height: 130.h,
                child: Image.asset(
                  'assets/images/register_top_logo.png',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 29.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create Account',
                      style: regularTextStyle(
                          fontSize: 27.sp,
                          textColor: AppColors.darkGrayTextColor),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 21.h),
                        child: PickImageAvatar(
                          callback: () {
                            // selectAvatarOptionsSheet(context);
                            confirmProfilePicSheet(context);
                          },
                        )),
                    TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: getAuthInputDecoration(
                        hintText: 'Full Name',
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: getAuthInputDecoration(
                        hintText: 'Phone Number',
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      decoration: getAuthInputDecoration(
                        hintText: 'Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    TextField(
                      cursorColor: Colors.black,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: getAuthInputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    SizedBox(
                        width: screenSize.width,
                        child: AuthCheckBoxGroup(
                          options: ['individual', 'buisness'],
                        )),
                    SizedBox(
                      height: 28.h,
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
                        child: Text('SIGN UP'),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "I'm already a member. ",
                          style: regularTextStyle(
                              fontSize: 12,
                              textColor: AppColors.darkGrayTextColor),
                        ),
                        TextSpan(
                            text: "SIGN IN",
                            style: semiBoldTextStyle(
                                fontSize: 12,
                                textColor: AppColors.darkGrayTextColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("SIGN IN");
                              }),
                      ]),
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
