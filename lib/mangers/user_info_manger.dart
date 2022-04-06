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

  static saveAnonFlag(value) async {
    await SharedPreferencesHelper.setInt('anonFlag', value);
  }

  static bool getAnonFlag() {
    try {
      return SharedPreferencesHelper.getInt('anonFlag') == 1;
    } catch (e) {
      return false;
    }
  }

  static saveRole(value) async {
    print('***************');
    print(value);
    await SharedPreferencesHelper.setString('role', value);
  }

  static bool isAdmin() {
    return SharedPreferencesHelper.getString('role') == 'admin';
  }
}
