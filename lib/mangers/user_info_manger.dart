import 'dart:convert';

import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/services/shared_preferences_helper.dart';

class UserInfoManger {
  static String getUserId() {
    return SharedPreferencesHelper.getString('userId');
  }

  static setUserId(userId) async {
    await SharedPreferencesHelper.setString('userId', userId);
  }

  static saveUserInfo(UserModel userModel) async {
    var decodedObject = jsonEncode(userModel.toJson());
    await SharedPreferencesHelper.setString('userInfo', decodedObject);
  }

  static clearUserInfo() async {
    await SharedPreferencesHelper.clearSharedPrefs();
  }

  static UserModel getUserInfo() {
    try {
      UserModel userModel = UserModel.fromJson(
          json.decode(SharedPreferencesHelper.getString('userInfo')));
      return userModel;
    } catch (e) {
      return UserModel(
          userName: '',
          email: '',
          photoUrl: '',
          fcmToken: '',
          store: false,
          uid: '');
    }
  }

  static saveAnonFlag() async {
    await SharedPreferencesHelper.setInt('anonFlag', 1);
  }

  static bool getAnonFlag() {
    return SharedPreferencesHelper.getInt('anonFlag') == 1;
  }
}
