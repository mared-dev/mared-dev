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
import 'package:mared_social/repositories/auth_repo.dart';
import 'package:mared_social/repositories/user_repo.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/authentication/login_screen.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/select_avatar_options_sheet.dart';
import 'package:mared_social/widgets/bottom_sheets/confirm_profile_pic_sheet.dart';
import 'package:mared_social/widgets/items/pick_image_avatar.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_group.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_item.dart';
import 'package:mared_social/widgets/reusable/password_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FillRemainingInfo extends StatefulWidget {
  final UserModel userModel;

  const FillRemainingInfo({Key? key, required this.userModel})
      : super(key: key);
  @override
  _FillRemainingInfoState createState() => _FillRemainingInfoState();
}

class _FillRemainingInfoState extends State<FillRemainingInfo> {
  File? _pickedImageFile;
  String _uploadedImageLink = "";

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  int isStore = -1;
  String userTypeError = "";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
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
                        'Fill remaining info',
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
                        width: screenSize.width,
                        child: AuthCheckBoxGroup(
                          changeSelectedItemCallback: (newIndex) {
                            if (newIndex == 0) {
                              isStore = 0;
                            } else {
                              isStore = 1;
                            }
                          },
                          options: ['individual', 'buisness'],
                        ),
                      ),
                      if (userTypeError.isNotEmpty)
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            userTypeError,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.errorColor),
                          ),
                        ),
                      SizedBox(
                        height: 28.h,
                      ),
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
                            } else if (isStore == -1) {
                              setState(() {
                                userTypeError = 'This field is required';
                              });
                            } else if (_formKey.currentState!.validate()) {
                              LoadingHelper.startLoading();
                              UserModel userToAdd = UserModel(
                                  userName: _nameController.text,
                                  email: widget.userModel.email,
                                  photoUrl: _uploadedImageLink,
                                  fcmToken: '',
                                  store: isStore == 1,
                                  bio: '',
                                  websiteLink: '',
                                  phoneNumber: _phoneNumberController.text,
                                  uid: widget.userModel.uid);
                              await UsersRepo.addUser(
                                  userModel: userToAdd, uid: userToAdd.uid);
                              LoadingHelper.endLoading();
                              await UserInfoManger.setUserId(userToAdd.uid);
                              await UserInfoManger.saveUserInfo(userToAdd);
                              await UserInfoManger.saveAnonFlag(0);

                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: const HomePage(),
                                    type: PageTransitionType.rightToLeft),
                              );
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
                          child: Text('Submit'),
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
