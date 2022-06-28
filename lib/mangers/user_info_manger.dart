import 'dart:convert';

import 'package:mared_social/models/user_cedentials_model.dart';
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
    await SharedPreferencesHelper.deleteItemWithKey('userInfo');
    await SharedPreferencesHelper.deleteItemWithKey('userId');
    await SharedPreferencesHelper.deleteItemWithKey('anonFlag');
    await SharedPreferencesHelper.deleteItemWithKey('role');
  }

  static UserModel getUserInfo() {
    try {
      UserModel userModel = UserModel.fromMap(
          json.decode(SharedPreferencesHelper.getString('userInfo')));
      return userModel;
    } catch (e) {
      print(e);
      return UserModel(
          userName: '',
          phoneNumber: '',
          email: '',
          photoUrl: '',
          fcmToken: '',
          store: false,
          bio: '',
          websiteLink: '',
          uid: '');
    }
  }

  static saveAnonFlag(value) async {
    await SharedPreferencesHelper.setInt('anonFlag', value);
  }

  static bool isNotGuest() {
    try {
      return SharedPreferencesHelper.getInt('anonFlag') == 0;
    } catch (e) {
      return false;
    }
  }

  static saveRole(value) async {
    await SharedPreferencesHelper.setString('role', value);
  }

  static bool isAdmin() {
    return SharedPreferencesHelper.getString('role') == 'admin';
  }

  static void rememberUser(
      {required String email, required String password}) async {
    await SharedPreferencesHelper.setString('savedEmail', email);
    await SharedPreferencesHelper.setString('savedPassword', password);
  }

  static Future<String> getRememberedEmail() async {
    return SharedPreferencesHelper.getString('savedEmail');
  }

  static Future<String> getRememberedPassword() async {
    return SharedPreferencesHelper.getString('savedPassword');
  }

  static void saveUsersCredentials(List<UserCredentialsModel> users) {
    String encodedCredentials = json.encode(
      users
          .map<Map<String, dynamic>>((user) => UserCredentialsModel.toMap(user))
          .toList(),
    );
    print(encodedCredentials);
    SharedPreferencesHelper.setString('savedCredentials', encodedCredentials);
  }

  static List<UserCredentialsModel> getSavedCredentials() {
    String savedCredentials = "";
    try {
      savedCredentials = SharedPreferencesHelper.getString('savedCredentials');
      return (json.decode(savedCredentials) as List<dynamic>)
          .map<UserCredentialsModel>(
              (item) => UserCredentialsModel.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
