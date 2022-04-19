import 'dart:convert';

class UserCredentialsModel {
  final String email;
  final String password;

  UserCredentialsModel({required this.email, required this.password});

  factory UserCredentialsModel.fromJson(Map<String, dynamic> jsonData) {
    return UserCredentialsModel(
      email: jsonData['email'],
      password: jsonData['password'],
    );
  }

  static Map<String, dynamic> toMap(
          UserCredentialsModel userCredentialsModel) =>
      {
        'email': userCredentialsModel.email,
        'password': userCredentialsModel.password,
      };

  static String encode(List<UserCredentialsModel> userCredentialsModel) =>
      json.encode(
        userCredentialsModel
            .map<Map<String, dynamic>>(
                (userModel) => UserCredentialsModel.toMap(userModel))
            .toList(),
      );

  static List<UserCredentialsModel> decode(String users) => (json.decode(users)
          as List<dynamic>)
      .map<UserCredentialsModel>((item) => UserCredentialsModel.fromJson(item))
      .toList();
}
