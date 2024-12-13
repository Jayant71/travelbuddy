import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:travelbuddy/data/sources/firebase_auth_services.dart';
import 'package:travelbuddy/data/sources/firebase_firestore_services.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseAuthServices>(FirebaseAuthServices());

  sl.registerSingleton<FirebaseFirestoreServices>(FirebaseFirestoreServices());
}
