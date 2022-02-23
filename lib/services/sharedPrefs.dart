import 'package:flutter/material.dart';
import 'package:mared_social/models/sharedPrefUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider with ChangeNotifier {
  SharedPrefUser? sharedPrefUser;
  SharedPrefUser? get getSharedPrefUser => sharedPrefUser;

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefUser? userData;
    var itemData = await prefs.getString("mydata")!;

    userData = sharedPrefUserFromJson(itemData);

    sharedPrefUser = userData;
  }
}
