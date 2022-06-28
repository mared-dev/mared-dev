import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<String> createAccount(String email, String password) async {
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
}
