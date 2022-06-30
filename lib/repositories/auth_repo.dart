import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/repositories/user_repo.dart';
import 'package:nanoid/nanoid.dart';

import '../mangers/user_info_manger.dart';

class AuthRepo {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static final GoogleSignIn googleSignIn = GoogleSignIn();

  static Future<String> createFirebaseAccount(
      String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    try {
      User? user = userCredential.user;
      return user!.uid;
    } catch (e) {
      print('-----------------------');
      print(e);
    }

    return '';
  }

  static Future<bool> emailSignUp(
      {required UserModel userModel, required String password}) async {
    try {
      String userUid =
          await AuthRepo.createFirebaseAccount(userModel.email, password);

      print('))))))))))))))))))');
      print(userModel.geoPoint.runtimeType);
      print(userModel.geoPoint.longitude);
      print(userModel.geoPoint.latitude);
      if (userUid.isNotEmpty) {
        UserModel registeredUser = UserModel(
            userName: userModel.userName,
            email: userModel.email,
            photoUrl: userModel.photoUrl,
            fcmToken: userModel.fcmToken,
            store: userModel.store,
            bio: userModel.bio,
            websiteLink: userModel.websiteLink,
            phoneNumber: userModel.phoneNumber,
            geoPoint: userModel.geoPoint,
            address: userModel.address,
            uid: userUid);

        await UserInfoManger.setUserId(userUid);
        await UserInfoManger.saveUserInfo(registeredUser);
        await UserInfoManger.saveAnonFlag(0);

        UsersRepo.addUser(userModel: registeredUser, uid: userUid);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('*************');
      print(e);
      return false;
    }
  }

  static Future<String> firebaseSignInAnon() async {
    try {
      var userCredential = await firebaseAuth.signInAnonymously();

      User? user = userCredential.user;
      return user!.uid;
    } catch (e) {
      print("FAILED === ${e.toString()}");
      return "";
    }
  }

  static Future<bool> loginAsGuest({context}) async {
    try {
      String anonUsername = nanoid(10).toString();
      String userUid = await firebaseSignInAnon();

      if (userUid.isNotEmpty) {
        UserModel userModel = UserModel.fromJson({
          'usercontactnumber': "",
          'store': false,
          'useruid': userUid,
          'useremail': "$anonUsername@mared.ae",
          'username': "@$anonUsername",
          'websiteLink': '',
          'bio': '',
          'fcmToken': '',
          'userimage':
              "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/userProfileAvatar%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2Ficon-mared.png?alt=media&token=eec2b470-f32e-4449-874a-e6929e210c6c",
        });

        await UserInfoManger.saveAnonFlag(1);
        await UserInfoManger.setUserId(userUid);
        await UserInfoManger.saveUserInfo(userModel);

        UsersRepo.addUser(userModel: userModel, uid: userUid);

        ///setting local data to use it later
        await UserInfoManger.setUserId(userUid);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User? user = userCredential.user;

    if (user == null) {
      return null;
    }

    return UserModel(
        userName: user.displayName!,
        email: user.email!,
        photoUrl: user.photoURL!,
        fcmToken: '',
        store: false,
        bio: '',
        websiteLink: '',
        address: '',
        geoPoint: GeoPoint(0, 0),
        phoneNumber: user.phoneNumber ?? "No Number",
        uid: user.uid);
  }

  static Future<UserModel?> loginWithGoogle() async {
    try {
      UserModel? userModel = await signInWithGoogle();
      return userModel;
    } catch (e) {
      print('------- error ---------- :');
      print(e);
      return Future.value(null);
    }
  }

  static Future signOut() async {
    await signOutWithGoogle();
    await logOutViaEmail();
  }

  static Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }

  static Future logOutViaEmail() {
    return firebaseAuth.signOut();
  }
}
