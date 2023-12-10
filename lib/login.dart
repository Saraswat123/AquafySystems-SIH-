import 'package:flutter/material.dart';
import 'package:water_resources/widgets.dart';

// ignore: must_be_immutable
class LogIn extends StatefulWidget {
  TextEditingController email;
  TextEditingController password;
  LogIn({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/Resources/BG.png'),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.15,
                    ),
                    FontText(
                        text: "Log In",
                        weight: FontWeight.w300,
                        size: height * 0.06),
                    SizedBox(
                      height: height * 0.07,
                    ),
                    InBox(
                      name: 'Email:',
                      controller: widget.email,
                      obscure: false,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    InBox(
                      name: 'Password:',
                      controller: widget.password,
                      obscure: true,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 10),
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
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {},
                    child: FontText(
                        text: "Isn't Signed in, Sign in.",
                        weight: FontWeight.w100,
                        size: height * 0.02)),
              ],
            ),
          )),
    );
  }
}
