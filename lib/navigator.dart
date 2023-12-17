import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_resources/Pages/login.dart';
import 'package:water_resources/Pages/signin.dart';
import 'package:water_resources/Pages/verify.dart';

//to check if the email is verified
class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmail();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}


//For login and signin
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = false;

  void toggle() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogIn(
        showSigninPage: () {
          toggle();
        },
      );
    } else {
      return Signin(
        showLoginPage: () {
          toggle();
        },
      );
    }
  }
}
