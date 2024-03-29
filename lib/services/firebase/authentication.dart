import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

//TODO:move all functions to (AuthRepo)
class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String userUid = "";
  late String googleUsername, googleUseremail, googleUserImage, googlePhoneNo;

  late String appleUsername, appleUseremail, appleUserImage, applePhoneNo;

  String get getUserId => userUid;
  String get getgoogleUsername => googleUsername;
  String get getgoogleUseremail => googleUseremail;
  String get getgoogleUserImage => googleUserImage;
  String get getgooglePhoneNo => googlePhoneNo;

  String get getappleUsername => appleUsername;
  String get getappleUseremail => appleUseremail;
  String get getappleUserImage => appleUserImage;
  String get getapplePhoneNo => applePhoneNo;

  Future returningUserLogin(String uid) async {
    userUid = uid;
    UserInfoManger.saveAnonFlag(0);
    print("logged in " + userUid);
    notifyListeners();
  }

  Future loginIntoAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
    UserInfoManger.saveAnonFlag(0);
    print("logged in " + userUid);
    notifyListeners();
  }

  Future resetPassword(String email) async {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Future createAccount(String email, String password) async {
  //   UserCredential userCredential = await firebaseAuth
  //       .createUserWithEmailAndPassword(email: email, password: password);
  //
  //   User? user = userCredential.user;
  //   userUid = user!.uid;
  //   isAnon = false;
  //   print(userUid);
  //   notifyListeners();
  // }

  Future logOutViaEmail() {
    return firebaseAuth.signOut();
  }

  Future signInWithgoogle() async {
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
    assert(user!.uid != null);

    userUid = user!.uid;
    UserInfoManger.saveAnonFlag(0);
    googleUseremail = user.email!;
    googleUsername = user.displayName!;
    googleUserImage = user.photoURL!;
    googlePhoneNo = user.phoneNumber ?? "No Number";
    print("Google sign in => ${userUid} || ${user.email}");
    await saveLocalCredentials(userUid);

    notifyListeners();
  }

  Future<User> signInApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;

        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          final email = appleIdCredential.email;

          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';

            await firebaseUser.updateDisplayName(displayName);
            await firebaseUser.updateEmail(email!);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final user = await signInApple(scopes: [Scope.email, Scope.fullName]);
      userUid = user.uid;
      UserInfoManger.saveAnonFlag(0);

      appleUseremail = user.email!;
      appleUsername = user.email!;
      appleUserImage =
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/userProfileAvatar%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2Ficon-mared.png?alt=media&token=eec2b470-f32e-4449-874a-e6929e210c6c";
      applePhoneNo = "No Number";

      print("appleUsername == ${appleUsername}");

      await saveLocalCredentials(userUid);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveLocalCredentials(String newUserId) async {
    UserInfoManger.setUserId(newUserId);
  }
}
