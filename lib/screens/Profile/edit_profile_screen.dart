import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_place/google_place.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/general_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/select_avatar_options_sheet.dart';
import 'package:mared_social/widgets/bottom_sheets/confirm_profile_pic_sheet.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:provider/provider.dart';

import '../../widgets/reusable/select_address_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const EditProfileScreen({Key? key, required this.userModel})
      : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  File? _pickedImageFile;
  String _uploadedImageLink = "";
  String selectedLocation = "", selectedLat = "", selectedLng = "";
  late UserModel oldUserModel;
  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.userModel.userName;
    _bioController.text = widget.userModel.bio;
    _websiteController.text = widget.userModel.websiteLink;
    _phoneNumberController.text = widget.userModel.phoneNumber;

    oldUserModel = UserInfoManger.getUserInfo();
    selectedLocation = oldUserModel.address;
    selectedLat = oldUserModel.geoPoint.latitude.toString();
    selectedLng = oldUserModel.geoPoint.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: homeAppBar(context,
          title: 'edit_profile'.tr(),
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            child: Column(
              children: [
                SizedBox(
                  height: 31.h,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        InkWell(
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            radius: 55,
                            backgroundImage: (_pickedImageFile == null)
                                ? CachedNetworkImageProvider(
                                    widget.userModel.photoUrl) as ImageProvider
                                : FileImage(_pickedImageFile!),
                          ),
                          onTap: () {
                            selectAvatarOptionsSheet(
                                context: context,
                                setSelectedFileCallback: _setProfilePick);
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            width: 28,
                            height: 28,
                            child: Icon(
                              Icons.add,
                              color: AppColors.accentColor,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.accentColor, width: 1.5),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 22.h,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: getAuthInputDecoration(hintText: 'username'.tr()),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: _bioController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.words,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  minLines: 3,
                  decoration: getAuthInputDecoration(
                      hintText: 'bio'.tr(), verticalContentPadding: 11.h),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "bio_cant_be_empty".tr();
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: _websiteController,
                  decoration: getAuthInputDecoration(hintText: 'website'.tr()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      bool validURL =
                          Uri.parse(value).host == '' ? false : true;
                      if (!validURL) {
                        return 'please_enter_a_valid_url'.tr();
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration:
                      getAuthInputDecoration(hintText: 'phone_number'.tr()),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      //TODO:add phone number validation
                      if (!GeneralFirebaseHelpers.validateMobile(value)) {
                        return 'please_enter_a_valid_phone_number'.tr();
                      }
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                SelectAddressWidget(
                    startingAddress: selectedLocation,
                    setSelectedAddress:
                        (String address, String lat, String lng) {
                      selectedLocation = address;
                      selectedLat = lat;
                      selectedLng = lng;
                    },
                    buttonText: 'set_your_location'.tr()),
                SizedBox(
                  height: 33.h,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      LoadingHelper.startLoading();
                      await Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .updateUserProfile(
                              context: context,
                              phoneNumber: _phoneNumberController.text,
                              userUid: UserInfoManger.getUserId(),
                              photoUrl: _uploadedImageLink.isEmpty
                                  ? widget.userModel.photoUrl
                                  : _uploadedImageLink,
                              bio: _bioController.text,
                              address: selectedLocation,
                              store: oldUserModel.store,
                              fcmToken: oldUserModel.fcmToken,
                              geoPoint: GeoPoint(double.parse(selectedLat),
                                  double.parse(selectedLng)),
                              websiteLink: _websiteController.text);

                      LoadingHelper.endLoading();
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 11.h),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      primary: AppColors.widgetsBackground),
                  child: Text('save_changes'.tr()),
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
