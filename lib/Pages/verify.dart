import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'widgets.dart';
import 'package:aquafy_systems/navigator.dart';

// ignore: must_be_immutable
class VerifyEmail extends StatefulWidget {
  const VerifyEmail({
    super.key,
  });

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailverified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    isEmailverified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailverified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkVerificationEmail());
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkVerificationEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailverified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailverified) timer?.cancel();
    });
  }

  Future sendVerificationEmail() async {
    if (canResendEmail) {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    }
  }

  @override
  Widget build(BuildContext context) => (isEmailverified)
      ? const HomePage()
      : Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/BG.png'), fit: BoxFit.cover),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 40, left: 20, right: 20, bottom: 30),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                      image: AssetImage('assets/BG2.png'), fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    FontText(
                      text: "Verify Email",
                      weight: FontWeight.w300,
                      size: MediaQuery.of(context).size.height * 0.04,
                      color: const Color.fromRGBO(1, 133, 183, 1),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    FontText(
                      text: "A verification mail has been sent to your mail.",
                      weight: FontWeight.w100,
                      size: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.black,
                      overflow: TextOverflow.visible,
                      align: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                    ),
                    (canResendEmail)
                        ? ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 17, 162, 215),
                              ),
                            ),
                            onPressed: () {
                              timer?.cancel();
                              if (!isEmailverified) {
                                sendVerificationEmail();
                                timer = Timer.periodic(
                                  const Duration(seconds: 5),
                                  (_) => checkVerificationEmail(),
                                );
                              }
                              canResendEmail = true;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                FontText(
                                    text: "Resend Email",
                                    weight: FontWeight.w100,
                                    size: MediaQuery.of(context).size.height *
                                        0.023),
                              ],
                            ),
                          )
                        : const CircularProgressIndicator(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ),
                        );
                      },
                      child: FontText(
                        text: "Back",
                        weight: FontWeight.w100,
                        size: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.black,
                        overflow: TextOverflow.visible,
                        align: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
}
