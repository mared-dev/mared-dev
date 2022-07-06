import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/warning_text.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingHelpers {
  static loginWithApple(context) async {
    try {
      await Provider.of<Authentication>(context, listen: false)
          .signInWithApple(context)
          .whenComplete(() async {
        String name =
            "${Provider.of<Authentication>(context, listen: false).getappleUsername} ";

        List<String> splitList = name.split(" ");
        List<String> indexList = [];

        for (int i = 0; i < splitList.length; i++) {
          for (int j = 0; j < splitList[i].length; j++) {
            indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
          }
        }

        await Provider.of<FirebaseOperations>(context, listen: false)
            .createUserCollection(context, {
          'usercontactnumber': "No Number",
          'store': false,
          'useruid':
              Provider.of<Authentication>(context, listen: false).getUserId,
          'usersearchindex': indexList,
          'useremail': Provider.of<Authentication>(context, listen: false)
              .getappleUseremail,
          'username': Provider.of<Authentication>(context, listen: false)
              .getappleUsername,
          'userimage': Provider.of<Authentication>(context, listen: false)
              .getappleUserImage,
        });

        await UserInfoManger.setUserId(
            Provider.of<Authentication>(context, listen: false).getUserId);
        await UserInfoManger.saveUserInfo(UserModel(
            websiteLink: '',
            bio: '',
            address: '',
            geoPoint: GeoPoint(0, 0),
            postCategory: "",
            phoneNumber: Provider.of<Authentication>(context, listen: false)
                .applePhoneNo,
            uid: Provider.of<Authentication>(context, listen: false).getUserId,
            store: false,
            email: Provider.of<Authentication>(context, listen: false)
                .getappleUseremail,
            userName: Provider.of<Authentication>(context, listen: false)
                .getappleUsername,
            photoUrl: Provider.of<Authentication>(context, listen: false)
                .getappleUserImage,
            fcmToken: ''));
        await UserInfoManger.saveAnonFlag(0);

        Navigator.pushReplacement(
            context,
            PageTransition(
                child: HomePage(), type: PageTransitionType.rightToLeft));
      });
    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Sign In Failed",
        text: e.toString(),
      );
    }
  }

  static Future<bool> loginWithEmail({context, email, password}) async {
    try {
      await Provider.of<Authentication>(context, listen: false)
          .loginIntoAccount(email, password);

      await UserInfoManger.setUserId(
        Provider.of<Authentication>(context, listen: false).getUserId,
      );

      //TODO:use "UserRepo" instead
      var userSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(Provider.of<Authentication>(context, listen: false).getUserId)
          .get();

      var test = GeneralFirebaseHelpers.getGeoPointSafely(
          key: 'geoPoint', doc: userSnapShot);
      print(test);
      await UserInfoManger.saveUserInfo(UserModel(
          uid: Provider.of<Authentication>(context, listen: false).getUserId,
          store: userSnapShot['store'],
          phoneNumber: userSnapShot['usercontactnumber'],
          bio: GeneralFirebaseHelpers.getStringSafely(
              key: 'bio', doc: userSnapShot),
          websiteLink: GeneralFirebaseHelpers.getStringSafely(
              key: 'websiteLink', doc: userSnapShot),
          address: GeneralFirebaseHelpers.getStringSafely(
              key: 'address', doc: userSnapShot),
          postCategory: GeneralFirebaseHelpers.getStringSafely(
              key: 'postcategory', doc: userSnapShot),
          geoPoint: GeneralFirebaseHelpers.getGeoPointSafely(
              key: 'geoPoint', doc: userSnapShot),
          email: email,
          userName: userSnapShot['username'],
          photoUrl: userSnapShot.data()!['userimage'],
          fcmToken: ''));
      await UserInfoManger.saveAnonFlag(0);

      await UserInfoManger.saveRole((userSnapShot.data()!['role'] != null)
          ? userSnapShot.data()!['role']
          : "");
      print(UserInfoManger.isAdmin());

      Navigator.pushReplacement(
        context,
        PageTransition(child: HomePage(), type: PageTransitionType.rightToLeft),
      );
      return Future.value(true);
    } catch (e) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Sign In Failed",
          text: GeneralFirebaseHelpers.getFormattedAuthError(e));
      return Future.value(false);
    }
  }
}
