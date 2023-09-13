// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  //Signup a user in fima
  static Future<String?> fimaSignUp(
      {required String email, required String password}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    }  on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }
 
 //Login the User in
 static Future<String?> fimaLogin(
      {required String email, required String password}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }  on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }
}