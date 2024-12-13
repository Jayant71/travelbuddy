import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelbuddy/firebase_options.dart';
import 'package:travelbuddy/helpers/isSignedIn.dart';
import 'package:travelbuddy/presentation/auth/cubit/user_cubit.dart';
import 'package:travelbuddy/presentation/auth/login.dart';
import 'package:travelbuddy/presentation/landing/cubit/complete_requests_cubit.dart';
import 'package:travelbuddy/presentation/landing/cubit/delivery_requests_dart_cubit.dart';
import 'package:travelbuddy/presentation/landing/dashboard.dart';
import 'package:travelbuddy/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DeliveryRequestsDartCubit()),
        BlocProvider(create: (context) => CompleteRequestsCubit()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        title: 'Travel Buddy App',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: sl<FirebaseAuth>().isSignedIn() ? Dashboard() : LoginPage(),
      ),
    );
  }
}
