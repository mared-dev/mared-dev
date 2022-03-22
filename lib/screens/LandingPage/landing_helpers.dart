import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/warning_text.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

///TODO: change to another location when you create contollers
///

class LandingHelpers {
  static loginAsGuest({context}) async {
    try {
      String anonUsername = nanoid(10).toString();
      await Provider.of<Authentication>(context, listen: false).signInAnon();

      String name = "$anonUsername";

      List<String> splitList = name.split(" ");
      List<String> indexList = [];

      for (int i = 0; i < splitList.length; i++) {
        for (int j = 0; j < splitList[i].length; j++) {
          indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
        }
      }

      await Provider.of<FirebaseOperations>(context, listen: false)
          .createUserCollection(context, {
        'usercontactnumber': "",
        'store': false,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserId,
        'useremail': "$anonUsername@mared.ae",
        'username': "@$anonUsername",
        'usersearchindex': indexList,
        'userimage':
            "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/userProfileAvatar%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2Ficon-mared.png?alt=media&token=eec2b470-f32e-4449-874a-e6929e210c6c",
      });

      ///setting local data to use it later
      await UserInfoManger.setUserId(
        Provider.of<Authentication>(context, listen: false).getUserId,
      );

      await UserInfoManger.saveUserInfo(UserModel(
          uid: Provider.of<Authentication>(context, listen: false).getUserId,
          email: "$anonUsername@mared.ae",
          userName: "@$anonUsername",
          photoUrl:
              "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/userProfileAvatar%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2Ficon-mared.png?alt=media&token=eec2b470-f32e-4449-874a-e6929e210c6c",
          fcmToken: '',
          store: false));

      Navigator.pushReplacement(
          context,
          PageTransition(
              child: HomePage(), type: PageTransitionType.rightToLeft));
    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Sign In Failed",
        text: e.toString(),
      );
    }
  }

  static loginWithGoogle(BuildContext context) async {
    try {
      await Provider.of<Authentication>(context, listen: false)
          .signInWithgoogle();

      String name =
          "${Provider.of<Authentication>(context, listen: false).getgoogleUsername} ";

      List<String> splitList = name.split(" ");
      List<String> indexList = [];

      for (int i = 0; i < splitList.length; i++) {
        for (int j = 0; j < splitList[i].length; j++) {
          indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
        }
      }

      await UserInfoManger.setUserId(
          Provider.of<Authentication>(context, listen: false).getUserId);
      await UserInfoManger.saveUserInfo(UserModel(
          uid: Provider.of<Authentication>(context, listen: false).getUserId,
          store: false,
          email: Provider.of<Authentication>(context, listen: false)
              .getgoogleUseremail,
          userName: Provider.of<Authentication>(context, listen: false)
              .getgoogleUsername,
          photoUrl: Provider.of<Authentication>(context, listen: false)
              .getgoogleUserImage,
          fcmToken: ''));

      await Provider.of<FirebaseOperations>(context, listen: false)
          .createUserCollection(context, {
        'usercontactnumber': Provider.of<Authentication>(context, listen: false)
            .getgooglePhoneNo,
        'usersearchindex': indexList,
        'store': false,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserId,
        'useremail': Provider.of<Authentication>(context, listen: false)
            .getgoogleUseremail,
        'username': Provider.of<Authentication>(context, listen: false)
            .getgoogleUsername,
        'userimage': Provider.of<Authentication>(context, listen: false)
            .getgoogleUserImage,
      });

      Navigator.pushReplacement(
          context,
          PageTransition(
              child: HomePage(), type: PageTransitionType.rightToLeft));
    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Sign In Failed",
        text: e.toString(),
      );
    }
  }

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
            uid: Provider.of<Authentication>(context, listen: false).getUserId,
            store: false,
            email: Provider.of<Authentication>(context, listen: false)
                .getappleUseremail,
            userName: Provider.of<Authentication>(context, listen: false)
                .getappleUsername,
            photoUrl: Provider.of<Authentication>(context, listen: false)
                .getappleUserImage,
            fcmToken: ''));

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

  static loginWithEmail({context, email, password}) async {
    print('(((((((((((((((((');

    try {
      await Provider.of<Authentication>(context, listen: false)
          .loginIntoAccount(email, password);

      await UserInfoManger.setUserId(
        Provider.of<Authentication>(context, listen: false).getUserId,
      );

      var userSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(Provider.of<Authentication>(context, listen: false).getUserId)
          .get();

      await UserInfoManger.saveUserInfo(UserModel(
          uid: Provider.of<Authentication>(context, listen: false).getUserId,
          store: userSnapShot['store'],
          email: email,
          userName: userSnapShot['username'],
          photoUrl: userSnapShot.data()!['userimage'],
          fcmToken: ''));

      Navigator.pushReplacement(
        context,
        PageTransition(child: HomePage(), type: PageTransitionType.bottomToTop),
      );
    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Sign In Failed",
        text: e.toString(),
      );
    }
  }
}