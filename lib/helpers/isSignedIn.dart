import 'package:firebase_auth/firebase_auth.dart';

extension IsSignedIn on FirebaseAuth {
  bool isSignedIn() {
    final currentUser = this.currentUser;
    return currentUser != null;
  }
}
