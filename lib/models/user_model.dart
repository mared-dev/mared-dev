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

  UserModel(
      {required this.userName,
      required this.email,
      required this.photoUrl,
      required this.fcmToken,
      required this.store,
      required this.bio,
      required this.websiteLink,
      required this.phoneNumber,
      required this.uid});

  // {
  //
  //
  // 'useruid': Provider.of<Authentication>(
  // context,
  // listen: false)
  //     .getUserId,
  // 'useremail': _emailController.text,
  // 'username': _nameController.text,
  // 'userimage': _uploadedImageLink,
  // 'usersearchindex':
  // GeneralFirebaseHelpers.generateIndices(
  // _nameController.text),
  // }

  UserModel.fromJson(obj)
      : userName = obj['username'],
        email = obj['useremail'],
        photoUrl = obj['userimage'],
        fcmToken = obj['fcmToken'],
        store = obj['store'],
        uid = obj['useruid'],
        websiteLink = obj['websiteLink'] ?? '',
        phoneNumber = obj['usercontactnumber'],
        bio = obj['bio'] ?? '';

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
      "websiteLink": websiteLink
    };
  }
}
