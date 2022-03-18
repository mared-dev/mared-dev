import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/screens/LandingPage/landing_helpers.dart';
import 'package:mared_social/screens/authentication/login_screen.dart';
import 'package:mared_social/screens/authentication/signup_screen.dart';
import 'package:mared_social/widgets/reusable/landing_auth_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ConstantColors constantColors = ConstantColors();
  String _authStatus = 'Unknown';
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => initPlugin());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog
        if (await showCustomTrackingDialog(context)) {
          // Wait for dialog popping animation
          await Future.delayed(const Duration(milliseconds: 200));
          // Request system's tracking authorization dialog
          final TrackingStatus status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          setState(() => _authStatus = '$status');
        }
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    // print("UUID: $uuid");
  }

  Future<bool> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            // TextButton(
            //   onPressed: () => Navigator.pop(context, false),
            //   child: const Text("I'll decide later"),
            // ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenUtilObject = ScreenUtil();
    return SafeArea(
      child: Scaffold(
        backgroundColor: constantColors.whiteColor,
        body: Stack(
          children: [
            Positioned(
                bottom: 0,
                child: Container(
                  width: screenSize.width,
                  child: Image.asset(
                    'assets/images/landing_logo.png',
                    fit: BoxFit.fill,
                  ),
                )),
            Container(
              width: screenSize.width,
              height: screenSize.height,
              padding: EdgeInsets.only(
                left: screenUtilObject.setWidth(30),
                right: screenUtilObject.setWidth(30),
                top: screenUtilObject.setHeight(18),
              ),
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 14),
                      width: screenSize.width,
                      height: ScreenUtil().setHeight(193 + 24),
                      child: Image.asset(
                        'assets/images/landing_top_logo.png',
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: screenUtilObject.setHeight(32),
                  ),
                  Container(
                    width: screenSize.width,
                    child: Text(
                      'CONNECTING BUISNESSES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 31.sp,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: screenUtilObject.setHeight(40),
                  ),
                  Wrap(
                    children: [
                      LandingAuthButton(
                          buttonText: 'Sign in',
                          callback: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: LoginScreen(),
                                    type: PageTransitionType.rightToLeft));
                          }),
                      SizedBox(
                        width: screenUtilObject.setWidth(23),
                      ),
                      LandingAuthButton(
                          buttonText: 'Sign up',
                          callback: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SignUpScreen(),
                                    type: PageTransitionType.rightToLeft));
                          }),
                      SizedBox(
                        width: screenUtilObject.setWidth(23),
                      ),
                      LandingAuthButton(
                          buttonText: 'Guest',
                          callback: () async {
                            LoadingHelper.startLoading();
                            await LandingHelpers.loginAsGuest(context: context);
                            LoadingHelper.endLoading();
                          }),
                    ],
                  ),
                  Container(
                    width: screenSize.width,
                    margin: EdgeInsets.only(
                        top: screenUtilObject.setHeight(28),
                        bottom: screenUtilObject.setHeight(21)),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenUtilObject.setWidth(20)),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Divider(
                            color: AppColors.widgetsBackground,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenUtilObject.setWidth(8)),
                          child: Text(
                            'or',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Divider(
                            color: AppColors.widgetsBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          LandingHelpers.loginWithGoogle(context);
                        },
                        child: Image.asset(
                          'assets/icons/gmail_icon.png',
                          fit: BoxFit.fill,
                          width: 26.w,
                          height: 26.h,
                        ),
                      ),
                      SizedBox(
                        width: Platform.isIOS ? 25.w : 0,
                      ),
                      Platform.isIOS
                          ? GestureDetector(
                              onTap: () async {
                                LoadingHelper.startLoading();
                                await LandingHelpers.loginWithApple(context);
                                LoadingHelper.endLoading();
                              },
                              child: SvgPicture.asset(
                                'assets/icons/apple_icon.svg',
                                fit: BoxFit.fill,
                                width: 24.w,
                                height: 26.h,
                              ),
                            )
                          : Container()
                    ],
                  ),

                  // bodyColor(),
                  // Provider.of<LandingHelpers>(context, listen: false)
                  //     .bodyImage(context),
                  // Provider.of<LandingHelpers>(context, listen: false)
                  //     .taglineText(context),
                  // Provider.of<LandingHelpers>(context, listen: false)
                  //     .mainButton(context),
                  // Provider.of<LandingHelpers>(context, listen: false)
                  //     .exploreApp(context),
                  // Provider.of<LandingHelpers>(context, listen: false)
                  //     .privacyText(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bodyColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.5, 0.9],
          colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor,
          ],
        ),
      ),
    );
  }
}
