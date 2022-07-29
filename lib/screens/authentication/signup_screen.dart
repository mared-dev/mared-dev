import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
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

import '../../services/firebase/fcm_notification_Service.dart';
import '../../widgets/reusable/select_address_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _pickedImageFile;
  String _uploadedImageLink = "";

  final _formKey = GlobalKey<FormState>();
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  int isStore = -1;
  String userTypeError = "";
  String selectedLocation = "", selectedLat = "", selectedLng = "";
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    List<String> catNames =
        Provider.of<FirebaseOperations>(context, listen: false).catNames;
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
                  height: 37.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'create_account'.tr(),
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
                          hintText: 'full_name'.tr(),
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this_field_is_required'.tr();
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
                          hintText: 'phone_number'.tr(),
                        ),
                        controller: _phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this_field_is_required'.tr();
                          } else if (value.length < 10) {
                            return "please_enter_valid_phone_number".tr();
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
                          hintText: 'email_address'.tr(),
                        ),

                        ///add email validation later
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this_field_is_required'.tr();
                          }
                          return null;
                        },
                        controller: _emailController,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      PasswordTextField(
                        passwordController: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this_field_is_required'.tr();
                          } else if (value.length < 6) {
                            return "password_should_be_at_least".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      PasswordTextField(
                        passwordController: _confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this_field_is_required'.tr();
                          } else if (value != _passwordController.text) {
                            return "passwords_need_to_match".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: AuthCheckBoxGroup(
                          changeSelectedItemCallback: (newIndex) {
                            setState(() {
                              if (newIndex == 0) {
                                isStore = 0;
                              } else {
                                isStore = 1;
                              }
                            });
                          },
                          options: ['individual'.tr(), 'business'.tr()],
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
                        height: 18.h,
                      ),
                      SelectAddressWidget(
                          startingAddress: "",
                          setSelectedAddress:
                              (String address, String lat, String lng) {
                            selectedLocation = address;
                            selectedLat = lat;
                            selectedLng = lng;
                          },
                          buttonText: 'set_your_location'.tr()),
                      SizedBox(
                        height: (isStore == 1 || isStore == 0) ? 18.h : 0,
                      ),
                      Visibility(
                        visible: (isStore == 1 || isStore == 0),
                        child: Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.commentButtonColor),
                          padding: EdgeInsets.symmetric(horizontal: 21.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/category_icon.svg'),
                              SizedBox(
                                width: 6.w,
                              ),
                              DropdownButton(
                                underline: SizedBox(),
                                dropdownColor: AppColors.backGroundColor,
                                hint: Container(
                                  margin: EdgeInsets.only(right: 6.w),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      isStore == 1
                                          ? 'choose_a_category'.tr()
                                          : 'choose_your_interests'.tr(),
                                      style: regularTextStyle(
                                          fontSize: 11,
                                          textColor:
                                              AppColors.backGroundColor)),
                                ),
                                value: _selectedCategory,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                icon: SvgPicture.asset(
                                    'assets/icons/select_category_arrow.svg'),
                                selectedItemBuilder: (context) {
                                  return catNames
                                      .map<Widget>((item) => Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(item,
                                                style: regularTextStyle(
                                                    fontSize: 11,
                                                    textColor: AppColors
                                                        .backGroundColor)),
                                          ))
                                      .toList();
                                },
                                items: catNames.map((category) {
                                  return DropdownMenuItem(
                                    child: Text(category,
                                        style: regularTextStyle(
                                            fontSize: 11,
                                            textColor:
                                                AppColors.commentButtonColor)),
                                    value: category,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 21.h,
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_pickedImageFile != null) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "error".tr(),
                                text: "please_select_a_profile_picture".tr(),
                              );
                            } else if (selectedLocation.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "error".tr(),
                                text: "please_pick_a_location".tr(),
                              );
                            } else if (_selectedCategory == null ||
                                (_selectedCategory != null &&
                                    _selectedCategory!.isEmpty)) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "error".tr(),
                                text: "please_pick_a_category".tr(),
                              );
                            } else if (_formKey.currentState!.validate()) {
                              LoadingHelper.startLoading();
                              bool success = await AuthRepo.emailSignUp(
                                  userModel: UserModel(
                                      userName: _nameController.text,
                                      email: _emailController.text,
                                      photoUrl: '',
                                      fcmToken: '',
                                      store: isStore == 1,
                                      bio: '',
                                      websiteLink: '',
                                      phoneNumber: _phoneNumberController.text,
                                      address: selectedLocation,
                                      postCategory: _selectedCategory!,
                                      geoPoint: GeoPoint(
                                          double.parse(selectedLat),
                                          double.parse(selectedLng)),
                                      uid: ''),
                                  password: _passwordController.text);

                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: const HomePage(),
                                      type: PageTransitionType.rightToLeft),
                                );

                                if (isStore == 0) {
                                  _fcmNotificationService
                                      .subscribeUserToTopic(_selectedCategory!);
                                } else {
                                  _fcmNotificationService
                                      .sendNotificationToTopic(
                                          title: 'new_store'.tr(),
                                          body: 'new_store_launched_near_you'
                                              .tr(),
                                          topic: _selectedCategory!);
                                }
                              } else {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    title: "sign_up_failed".tr(),
                                    text: 'something_went_wrong'.tr());
                              }
                              LoadingHelper.endLoading();
                            } else {
                              if (isStore == -1) {
                                setState(() {
                                  userTypeError = 'this_field_is_required'.tr();
                                });
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
                          child: Text('sign_up'.tr()),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "im_already_member".tr(),
                            style: regularTextStyle(
                                fontSize: 12,
                                textColor: AppColors.darkGrayTextColor),
                          ),
                          TextSpan(
                              text: "sign_in".tr(),
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
