import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/firebase_general_helpers.dart';

class UserModel {
  final String userName;
  final String email;
  final String photoUrl;
  final String fcmToken;
  final String bio;
  final String websiteLink;
  final String uid;
  final bool store;
  final String phoneNumber;
  final String address;
  final GeoPoint geoPoint;

  UserModel(
      {required this.address,
      required this.geoPoint,
      required this.userName,
      required this.email,
      required this.photoUrl,
      required this.fcmToken,
      required this.store,
      required this.bio,
      required this.websiteLink,
      required this.phoneNumber,
      required this.uid});

  UserModel.fromJson(obj)
      : userName = obj['username'],
        email = obj['useremail'],
        photoUrl = obj['userimage'],
        fcmToken = obj['fcmToken'],
        store = obj['store'],
        uid = obj['useruid'],
        address =
            GeneralFirebaseHelpers.getStringSafely(key: 'address', doc: obj),
        geoPoint =
            GeneralFirebaseHelpers.getGeoPointSafely(key: 'geoPoint', doc: obj),
        websiteLink = GeneralFirebaseHelpers.getStringSafely(
            key: 'websiteLink', doc: obj),
        phoneNumber = obj['usercontactnumber'],
        bio = GeneralFirebaseHelpers.getStringSafely(key: 'bio', doc: obj);

  toJson() {
    return {
      "username": userName,
      "useremail": email,
      "store": store,
      "userimage": photoUrl,
      "fcmToken": fcmToken,
      "useruid": uid,
      "bio": bio,
      'usercontactnumber': phoneNumber,
      "websiteLink": websiteLink,
      "address": address,
      'geoPoint': GeneralFirebaseHelpers.geoPointToString(geoPoint)
    };
  }
}
