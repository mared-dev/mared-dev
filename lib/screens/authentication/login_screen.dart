import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/general_styles.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_cedentials_model.dart';
import 'package:mared_social/repositories/auth_repo.dart';
import 'package:mared_social/repositories/user_repo.dart';
import 'package:mared_social/screens/LandingPage/landing_helpers.dart';
import 'package:mared_social/screens/authentication/fill_remaining_info.dart';
import 'package:mared_social/screens/authentication/forgot_password_screen.dart';
import 'package:mared_social/screens/authentication/signup_screen.dart';
import 'package:mared_social/utils/popup_utils.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_item.dart';
import 'package:mared_social/widgets/reusable/sign_in_with_google_button.dart';
import 'package:mared_social/widgets/reusable/password_text_field.dart';
import 'package:page_transition/page_transition.dart';

import '../../helpers/firebase_general_helpers.dart';
import '../../models/user_model.dart';
import '../../services/firebase/fcm_notification_Service.dart';
import '../../widgets/reusable/sign_in_with_apple_button.dart';
import '../HomePage/homepage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = true;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _initRememberedCredentials();
    // WidgetsBinding.instance!
    //     .addPostFrameCallback((_) => _initRememberedCredentials());
  }

  List<UserCredentialsModel> savedCredentials = [];

  late Size _screenSize;
  late ScreenUtil _screenUtilObject;
  @override
  Widget build(BuildContext context) {
    _screenUtilObject = ScreenUtil();
    _screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backGroundColor,
        body: Container(
          padding: EdgeInsets.only(
            top: 18.h,
          ),
          width: _screenSize.width,
          height: _screenSize.height,
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 75.w),
                      margin: EdgeInsets.only(top: 48.h),
                      width: _screenSize.width,
                      height: 120.h,
                      child: Image.asset(
                        'assets/images/login_top_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
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
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _emailController,
                              autofocus: false,
                              enableSuggestions: true,
                              enableInteractiveSelection: true,
                              scrollPadding: EdgeInsets.only(bottom: 120.h),
                              decoration: getAuthInputDecoration(
                                prefixIcon: Icons.email_outlined,
                                hintText: 'Email address',
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              List<UserCredentialsModel> foundList =
                                  savedCredentials
                                      .where((element) =>
                                          element.email.contains(pattern))
                                      .toList();
                              return Future.value(foundList);
                            },
                            errorBuilder: (context, _) {
                              return Container();
                            },
                            hideOnEmpty: true,
                            itemBuilder:
                                (context, UserCredentialsModel suggestion) {
                              return Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Text(suggestion.email.toString()));
                            },
                            onSuggestionSelected:
                                (UserCredentialsModel suggestion) {
                              _emailController.text =
                                  suggestion.email.toString();
                              _passwordController.text =
                                  suggestion.password.toString();
                            },
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          PasswordTextField(
                            passwordController: _passwordController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              }
                              return "This field can't be empty";
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _rememberMeButton(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: ForgotPasswordScreen(),
                                          type:
                                              PageTransitionType.rightToLeft));
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 17.h, bottom: 28.h),
                                  child: Text(
                                    'Forgot password ?',
                                    textAlign: TextAlign.end,
                                    style: regularTextStyle(
                                        fontSize: 14.sp,
                                        textColor: AppColors.darkGrayTextColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: _screenSize.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_emailController.text.isEmpty) {
                                  PopupUtils.showFailurePopup(
                                      title: 'Failed',
                                      body: "Email address can't be empty",
                                      context: context);
                                } else if (_formKey.currentState!.validate()) {
                                  LoadingHelper.startLoading();

                                  bool isSuccessfulLogin =
                                      await LandingHelpers.loginWithEmail(
                                          context: context,
                                          email: _emailController.text,
                                          password: _passwordController.text);

                                  if (isSuccessfulLogin) {
                                    UserInfoManger.rememberUser(
                                        email: _emailController.text,
                                        password: _passwordController.text);

                                    if (!savedCredentials.any((element) =>
                                        element.email ==
                                        _emailController.text)) {
                                      savedCredentials.add(UserCredentialsModel(
                                          email: _emailController.text,
                                          password: _passwordController.text));

                                      UserInfoManger.saveUsersCredentials(
                                          savedCredentials);
                                    }
                                  }
                                  LoadingHelper.endLoading();
                                }
                              },
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
                          _orDivider(),
                          SignInWithGoogleButton(
                            buttonText: 'Sign in with google',
                            callback: () async {
                              LoadingHelper.startLoading();
                              UserModel? loggedInUser =
                                  await AuthRepo.loginWithGoogle();
                              if (loggedInUser != null) {
                                UserModel? storedUser =
                                    await UsersRepo.getUser(loggedInUser.uid);
                                LoadingHelper.endLoading();
                                if (storedUser == null) {
                                  await AuthRepo.signOut();

                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: FillRemainingInfo(
                                            userModel: loggedInUser,
                                          ),
                                          type:
                                              PageTransitionType.rightToLeft));
                                } else {
                                  await UserInfoManger.setUserId(
                                      storedUser.uid);
                                  await UserInfoManger.saveUserInfo(storedUser);
                                  await UserInfoManger.saveAnonFlag(0);
                                  LoadingHelper.endLoading();
                                  FCMNotificationService().subscribeUserToTopic(
                                      storedUser.postCategory);
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: const HomePage(),
                                          type:
                                              PageTransitionType.rightToLeft));
                                }

                                //TODO: let the user subscribe to some category
                              } else {
                                LoadingHelper.endLoading();
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "Sign In Failed",
                                  text: "Something went wrong",
                                );
                              }
                            },
                          ),
                          if (Platform.isIOS)
                            SizedBox(
                              height: 13.h,
                            ),
                          if (Platform.isIOS)
                            SignInWithAppleButton(
                              buttonText: 'Sign in with Apple',
                              callback: () async {
                                LoadingHelper.startLoading();
                                await LandingHelpers.loginWithApple(context);
                                LoadingHelper.endLoading();
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 18.h),
          width: MediaQuery.of(context).size.width,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "I'm a new user .",
                style: regularTextStyle(
                    fontSize: 12, textColor: AppColors.darkGrayTextColor),
              ),
              TextSpan(
                  text: "SIGN UP",
                  style: semiBoldTextStyle(
                      fontSize: 12, textColor: AppColors.darkGrayTextColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: SignUpScreen(),
                              type: PageTransitionType.rightToLeft));
                    }),
            ]),
          ),
        ),
      ),
    );
  }

  _initRememberedCredentials() async {
    _emailController.text = await UserInfoManger.getRememberedEmail();
    _passwordController.text = await UserInfoManger.getRememberedPassword();

    savedCredentials = UserInfoManger.getSavedCredentials();
  }

  Widget _orDivider() {
    return Container(
      width: _screenSize.width,
      margin: EdgeInsets.only(
          top: _screenUtilObject.setHeight(26),
          bottom: _screenUtilObject.setHeight(24)),
      padding: EdgeInsets.symmetric(horizontal: _screenUtilObject.setWidth(20)),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Divider(
              color: AppColors.widgetsBackground,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _screenUtilObject.setWidth(8)),
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
    );
  }

  Widget _rememberMeButton() {
    return StatefulBuilder(
      builder: (BuildContext context,
          void Function(void Function()) setButtonState) {
        return GestureDetector(
          onTap: () {
            setButtonState(() {
              rememberMe = !rememberMe;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 6, bottom: 22.h),
            child: AuthCheckboxItem(
              optionText: 'Remeber me',
              isSelected: rememberMe,
            ),
          ),
        );
      },
    );
  }
}
