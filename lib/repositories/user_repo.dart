import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanoid/async.dart';

import '../helpers/firebase_general_helpers.dart';
import '../models/user_model.dart';

class UsersRepo {
  static final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  static Future<UserModel> getUser(String uid) async {
    var userObj = await collection.doc(uid).get();

    return Future.value(UserModel.fromJson(userObj));
  }

  static Future<void> addUser(
      {required UserModel userModel, required String uid}) async {
    var dataToAdd = userModel.toJson();
    dataToAdd['usersearchindex'] =
        GeneralFirebaseHelpers.generateIndices(userModel.userName);

    return collection.doc(uid).set(dataToAdd);
  }

  static void updateUser(UserModel userModel) async {
    await collection.doc(userModel.uid).update(userModel.toJson());
  }

  static void deleteUser(String uid) async {
    await collection.doc(uid).delete();
  }
}
