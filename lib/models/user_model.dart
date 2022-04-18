class UserModel {
  final String userName;
  final String email;
  final String photoUrl;
  final String fcmToken;
  final String bio;
  final String websiteLink;
  final String uid;
  final bool store;

  UserModel(
      {required this.userName,
      required this.email,
      required this.photoUrl,
      required this.fcmToken,
      required this.store,
      required this.bio,
      required this.websiteLink,
      required this.uid});

  UserModel.fromJson(obj)
      : userName = obj['userName'],
        email = obj['email'],
        photoUrl = obj['photoUrl'],
        fcmToken = obj['fcmToken'],
        store = obj['store'],
        uid = obj['uid'],
        websiteLink = obj['websiteLink'] ?? '',
        bio = obj['bio'] ?? '';
  toJson() {
    return {
      "userName": userName,
      "email": email,
      "store": store,
      "photoUrl": photoUrl,
      "fcmToken": fcmToken,
      "uid": uid,
      "bio": bio,
      "websiteLink": websiteLink
    };
  }
}
