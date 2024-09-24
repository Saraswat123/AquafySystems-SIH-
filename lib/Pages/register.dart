import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

// ignore: must_be_immutable
class Signin extends StatefulWidget {
  final VoidCallback showLoginPage;
  const Signin({
    super.key,
    required this.showLoginPage,
  });

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final fname = TextEditingController();
  final lname = TextEditingController();
  final email = TextEditingController();
  final pwd = TextEditingController();
  final confirmpwd = TextEditingController();
  String error = "";
  bool isSign = false;

  @override
  void dispose() {
    email.dispose();
    fname.dispose();
    lname.dispose();
    pwd.dispose();
    confirmpwd.dispose();
    super.dispose();
  }

  Future signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), password: pwd.text.trim());
      addUserDetails(fname.text.trim(), lname.text.trim(), email.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          isSign = false;
          error = 'Email is already in use.';
        });
      } else {
        setState(() {
          isSign = false;
          error = "An error occured-$e.code";
        });
      }
    }
  }

  Future addUserDetails(String fname, String lname, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'First Name': fname,
      'Email': email,
      'Last name': lname,
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/BG.png'), fit: BoxFit.cover)),
          child: SizedBox(
            width: width * 0.1,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      FontText(
                        text: "Register Now!",
                        weight: FontWeight.w600,
                        size: height * 0.04,
                      ),
                      FontText(
                        text: "Sign up & start your journey today",
                        weight: FontWeight.w400,
                        size: height * 0.02,
                      ),
                      SizedBox(
                        height: height * 0.07,
                      ),
                      InBox(
                        name: 'First Name:',
                        controller: fname,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      InBox(
                        name: 'Last Name:',
                        controller: lname,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      InBox(
                        name: 'Email:',
                        controller: email,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      InBox(
                        name: 'Password:',
                        controller: pwd,
                        obscure: true,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      InBox(
                        name: 'Confirm Password:',
                        controller: confirmpwd,
                        obscure: true,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      FontText(
                        text: error,
                        weight: FontWeight.w100,
                        size: height * 0.015,
                        color: const Color.fromARGB(255, 200, 24, 42),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      (isSign)
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSign = true;
                                });
                                if (email.text.isNotEmpty) {
                                  if (pwd.text.trim() ==
                                          confirmpwd.text.trim() &&
                                      pwd.text.isNotEmpty &&
                                      confirmpwd.text.isNotEmpty) {
                                    signup();
                                  } else {
                                    setState(() {
                                      isSign = false;
                                      error = 'Check password';
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isSign = false;
                                    error = 'Enter Email and Password';
                                  });
                                }
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
                                    text: "Sign Up",
                                    weight: FontWeight.w100,
                                    size: height * 0.03),
                              ),
                            )
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      widget.showLoginPage();
                    },
                    child: FontText(
                      text: "Already signed in, Log in.",
                      weight: FontWeight.w100,
                      size: height * 0.02,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
