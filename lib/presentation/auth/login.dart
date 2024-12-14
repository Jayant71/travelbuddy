import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travelbuddy/data/sources/firebase_auth_services.dart';
import 'package:travelbuddy/helpers/loading.dart';
import 'package:travelbuddy/presentation/auth/namepage.dart';
import 'package:travelbuddy/presentation/auth/signup.dart';
import 'package:travelbuddy/presentation/landing/dashboard.dart';
import 'package:travelbuddy/service_locator.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email cannot be empty';
                  } else if (!value.contains('@')) {
                    return 'Invalid email address';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.showLoadingDialog();
                    sl<FirebaseAuthServices>()
                        .signInWithEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    )
                        .then((result) async {
                      if (context.mounted) {
                        if (result == "Success") {
                          context.hideLoadingDialog();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ));
                        } else {
                          context.hideLoadingDialog();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result!),
                            ),
                          );
                        }
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  context.showLoadingDialog();
                  final result =
                      await sl<FirebaseAuthServices>().signInWithGoogle();
                  if (context.mounted) {
                    if (result == "ExistingUser") {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ));
                    } else if (result == "NewUser") {
                      context.hideLoadingDialog();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => NamePage(),
                      ));
                    } else if (result == "Failed") {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result!),
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: SvgPicture.asset(
                  'assets/google_logo.svg',
                  width: 24,
                  height: 24,
                ),
                label: const Text('Sign in with Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ));
                },
                // style: TextButton.styleFrom(
                //   padding: const EdgeInsets.symmetric(vertical: 16),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                // ),
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
