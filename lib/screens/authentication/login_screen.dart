import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/general_styles.dart';
import 'package:mared_social/constants/text_styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backGroundColor,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 18.h,
            ),
            width: screenSize.width,
            height: screenSize.height,
            child: Column(
              children: [
                Container(
                  width: screenSize.width,
                  height: 291.h,
                  child: Image.asset(
                    'assets/images/login_top_logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login to Mared App',
                        style: regularTextStyle(
                            fontSize: 14.sp,
                            textColor: AppColors.darkGrayTextColor),
                      ),
                      SizedBox(
                        height: 28.h,
                      ),
                      TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: getAuthInputDecoration(
                          prefixIcon: Icons.email_outlined,
                          hintText: 'Email address',
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
                          prefixIcon: Icons.lock_outline,
                          hintText: 'Password',
                        ),
                      ),
                      SizedBox(
                        height: 17.h,
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: Text(
                          'Forgot password ?',
                          textAlign: TextAlign.end,
                          style: regularTextStyle(
                              fontSize: 14.sp,
                              textColor: AppColors.darkGrayTextColor),
                        ),
                      ),
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
                          child: Text('SIGN IN'),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "I'm a new user .",
                            style: regularTextStyle(
                                fontSize: 12,
                                textColor: AppColors.darkGrayTextColor),
                          ),
                          TextSpan(
                              text: "SIGN UP",
                              style: semiBoldTextStyle(
                                  fontSize: 12,
                                  textColor: AppColors.darkGrayTextColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print("SIGN UUUUUP");
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
      ),
    );
  }
}
