import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/general_styles.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/screens/authentication/login_screen.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/select_avatar_options_sheet.dart';
import 'package:mared_social/widgets/bottom_sheets/confirm_profile_pic_sheet.dart';
import 'package:mared_social/widgets/items/pick_image_avatar.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_group.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _pickedImageFile;
  String _uploadedImageLink = "";

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;

  bool isStore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backGroundColor,
        body: Form(
          key: _formKey,
          child: Container(
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
                            selectedFile: _pickedImageFile,
                            callback: () {
                              selectAvatarOptionsSheet(
                                  context: context,
                                  setSelectedFileCallback: _setProfilePick);
                              // confirmProfilePicSheet(context);
                            },
                          )),
                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: getAuthInputDecoration(
                          hintText: 'Full Name',
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        decoration: getAuthInputDecoration(
                          hintText: 'Phone Number',
                        ),
                        controller: _phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          } else if (value.length < 10) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: getAuthInputDecoration(
                          hintText: 'Email Address',
                        ),

                        ///add email validation later
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        controller: _emailController,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: getAuthInputDecoration(
                          hintText: 'Password',
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          } else if (value.length < 6) {
                            return "password should be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                          width: screenSize.width,
                          child: AuthCheckBoxGroup(
                            changeSelectedItemCallback: (newIndex) {
                              if (newIndex == 0) {
                                isStore = false;
                              } else {
                                isStore = true;
                              }
                            },
                            options: ['individual', 'buisness'],
                          )),
                      SizedBox(
                        width: screenSize.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_pickedImageFile == null) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "Error",
                                text: "Please select a profile picture",
                              );
                            } else if (_formKey.currentState!.validate()) {
                              LoadingHelper.startLoading();
                              try {
                                await Provider.of<Authentication>(context,
                                        listen: false)
                                    .createAccount(_emailController.text,
                                        _passwordController.text);

                                ///remove this section later
                                SharedPreferences.setMockInitialValues({});
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'mydata',
                                    json.encode({
                                      'userpassword': _passwordController.text,
                                      'usercontactnumber':
                                          _phoneNumberController.text,
                                      'store': isStore,
                                      'useruid': Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserId,
                                      'useremail': _emailController.text,
                                      'username': _nameController.text,
                                      'userimage': _uploadedImageLink,
                                    }));

                                ///

                                await UserInfoManger.setUserId(
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserId,
                                );
                                await UserInfoManger.saveUserInfo(UserModel(
                                    uid: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId,
                                    store: isStore,
                                    email: _emailController.text,
                                    userName: _nameController.text,
                                    photoUrl: _uploadedImageLink,
                                    fcmToken: ''));

                                String name = "${_nameController.text} ";

                                List<String> splitList = name.split(" ");
                                List<String> indexList = [];

                                for (int i = 0; i < splitList.length; i++) {
                                  for (int j = 0;
                                      j < splitList[i].length;
                                      j++) {
                                    indexList.add(splitList[i]
                                        .substring(0, j + 1)
                                        .toLowerCase());
                                  }
                                }

                                await Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .createUserCollection(context, {
                                  'userpassword': _nameController.text,
                                  'usercontactnumber':
                                      _phoneNumberController.text,
                                  'store': isStore,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserId,
                                  'useremail': _emailController.text,
                                  'username': _nameController.text,
                                  'userimage': _uploadedImageLink,
                                  'usersearchindex': indexList,
                                });

                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: const HomePage(),
                                      type: PageTransitionType.bottomToTop),
                                );
                              } catch (e) {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "Sign In Failed",
                                  text: e.toString(),
                                );
                              } finally {
                                LoadingHelper.endLoading();
                              }
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
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: LoginScreen(),
                                          type:
                                              PageTransitionType.rightToLeft));
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

  _setProfilePick(File pickedFile) {
    setState(() {
      _pickedImageFile = pickedFile;
    });
    confirmProfilePicSheet(
        context: context,
        imageFile: pickedFile,
        setUploadedImageLinkCallback: _setUploadedImageLinkCallback);
  }

  _setUploadedImageLinkCallback(imageLink) {
    _uploadedImageLink = imageLink;
  }
}
