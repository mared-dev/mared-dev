import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserResultItem extends StatelessWidget {
  final dynamic userData;

  const UserResultItem({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: () {
          if (userData['useruid'] != UserInfoManger.getUserId()) {
            Navigator.push(
                context,
                PageTransition(
                    child: AltProfile(
                      userModel: UserModel(
                          phoneNumber: GeneralFirebaseHelpers.getStringSafely(
                              key: 'usercontactnumber', doc: userData),
                          websiteLink: GeneralFirebaseHelpers.getStringSafely(
                              key: 'websiteLink', doc: userData),
                          bio: GeneralFirebaseHelpers.getStringSafely(
                              key: 'bio', doc: userData),
                          postCategory: GeneralFirebaseHelpers.getStringSafely(
                              key: 'postcategory', doc: userData),
                          address: GeneralFirebaseHelpers.getStringSafely(
                              key: 'address', doc: userData),
                          geoPoint: GeneralFirebaseHelpers.getGeoPointSafely(
                              key: 'geoPoint', doc: userData),
                          uid: userData['useruid'],
                          userName: userData['username'],
                          photoUrl: userData['userimage'],
                          email: userData['useremail'],
                          fcmToken: "",

                          ///later you have to give this the right value
                          store: false),
                      userUid: userData['useruid'],
                    ),
                    type: PageTransitionType.rightToLeft));
          } else {
            IsAnonBottomSheet(context);
          }
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: userData['userimage'],
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
              height: 50,
              width: 50,
              child: LoadingWidget(constantColors: constantColors),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          userData['username'],
          style: TextStyle(color: AppColors.commentButtonColor),
        ),
      ),
    );
  }
}
