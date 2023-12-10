import 'package:flutter/material.dart';
import 'package:water_resources/homepage.dart';
import 'package:water_resources/login.dart';
import 'package:water_resources/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController myController1;
  late TextEditingController myController2;
  late TextEditingController myController3;

  @override
  void initState() {
    super.initState();
    myController1 = TextEditingController();
    myController2 = TextEditingController();
    myController3 = TextEditingController();
  }

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myController3.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(13, 75, 150, 1))),
      debugShowCheckedModeBanner: false,

      // home: const HomePage(
      //   name: 'Dinesh',
      //   tds: 7,
      //   turbidity: 0.333,
      //   temperature: 5,
      //   dO: 54,
      //   pH: 0,
      //   pressure: 0,
      //   depth: 0,
      //   flowDischarge: 0,
      // ),

      // home: Signin(
      //   email: myController1,
      //   pwd: myController2,
      //   confirmpwd: myController3,
      // ),

      home: LogIn(email: myController1, password: myController2),
    );
  }
}
