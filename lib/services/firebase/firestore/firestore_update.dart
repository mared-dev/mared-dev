import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FireStoreUpdate {
  static Future<bool> checkIfShouldUpdate(BuildContext context) async {
    var updateInfo =
        await FirebaseFirestore.instance.collection("updates").get();

    var updateInfoDocs = updateInfo.docs[0].data();
    int androidVersionCode = int.parse(updateInfoDocs['androidVersionCode']);
    int iosVersionCode = int.parse(updateInfoDocs['iosVersionCode']);
    int leastSupportedIos = int.parse(updateInfoDocs['leastSupportedIos']);
    int leastSupportedAndroid =
        int.parse(updateInfoDocs['leastSupportedAndroid']);

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if ((Platform.isAndroid &&
              int.parse(packageInfo.buildNumber) < leastSupportedAndroid) ||
          (Platform.isIOS &&
              int.parse(packageInfo.buildNumber) < leastSupportedIos)) {
        return Future.value(true);
      }
    } catch (e) {
      print(e);
    }
    return Future.value(false);
  }
}
