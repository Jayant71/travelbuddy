import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in flow
        return "Canceled";
      }
      return "Success";
    } catch (e) {
      debugPrint(e.toString());
      return "Failed";
    }
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<String?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
