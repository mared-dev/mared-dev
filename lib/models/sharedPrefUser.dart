// To parse this JSON data, do
//
//     final sharedPrefUser = sharedPrefUserFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SharedPrefUser sharedPrefUserFromJson(String str) =>
    SharedPrefUser.fromJson(json.decode(str));

String sharedPrefUserToJson(SharedPrefUser data) => json.encode(data.toJson());

class SharedPrefUser {
  SharedPrefUser({
    @required this.userpassword,
    @required this.usercontactnumber,
    @required this.store,
    @required this.useruid,
    @required this.useremail,
    @required this.username,
    @required this.userimage,
  });

  String? userpassword;
  String? usercontactnumber;
  bool? store;
  String? useruid;
  String? useremail;
  String? username;
  String? userimage;

  factory SharedPrefUser.fromJson(Map<String, dynamic> json) => SharedPrefUser(
        userpassword: json["userpassword"],
        usercontactnumber: json["usercontactnumber"],
        store: json["store"],
        useruid: json["useruid"],
        useremail: json["useremail"],
        username: json["username"],
        userimage: json["userimage"],
      );

  Map<String, dynamic> toJson() => {
        "userpassword": userpassword,
        "usercontactnumber": usercontactnumber,
        "store": store,
        "useruid": useruid,
        "useremail": useremail,
        "username": username,
        "userimage": userimage,
      };
}
