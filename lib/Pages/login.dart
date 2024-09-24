import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'widgets.dart';

// ignore: must_be_immutable
class LogIn extends StatefulWidget {
  VoidCallback showSigninPage;
  LogIn({
    super.key,
    required this.showSigninPage,
  });

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final email = TextEditingController();
  final password = TextEditingController();
  String error = '';
  bool isloading = false;

  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      if (mounted) {
        setState(() {
          error = '';
          isloading = false;
        });
      }
    } on FirebaseAuthException {
      if (mounted) {
        setState(() {
          isloading = false;
          error = "Check your Email And Password";
        });
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/BG.png'), fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    FontText(
                      text: "Welcome back!",
                      weight: FontWeight.w600,
                      size: height * 0.04,
                    ),
                    FontText(
                      text: "Log in into your account",
                      weight: FontWeight.w400,
                      size: height * 0.02,
                    ),
                    SizedBox(
                      height: height * 0.15,
                    ),
                    InBox(
                      name: 'Email:',
                      controller: email,
                      obscure: false,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    InBox(
                      name: 'Password:',
                      controller: password,
                      obscure: true,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    FontText(
                      text: error,
                      weight: FontWeight.w100,
                      size: height * 0.02,
                      color: const Color.fromARGB(255, 200, 24, 42),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          error = '';
                          isloading = true;
                        });
                        login();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: height * 0.05,
                        width: width * 0.4,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(69, 166, 255, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: FontText(
                            text: "Confirm",
                            weight: FontWeight.w100,
                            size: height * 0.03),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    if (isloading) const CircularProgressIndicator(),
                  ],
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    widget.showSigninPage();
                  },
                  child: FontText(
                    text: "Isn't a member, Sign in.",
                    weight: FontWeight.w100,
                    size: height * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
