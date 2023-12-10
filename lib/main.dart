import 'package:flutter/material.dart';
import 'package:water_resources/Pages/homepage.dart';
import 'package:water_resources/Pages/login.dart';
import 'package:water_resources/Pages/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController controller1;
  late TextEditingController controller2;
  late TextEditingController controller3;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose(); // Dispose the controller to prevent memory leaks
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
      //MAIN PAGE WITH PARAMETERS
      home: const HomePage(
        name: 'Dinesh',
        tds: 7,
        turbidity: 0.333,
        temperature: 5,
        dO: 54,
        pH: 0,
        pressure: 0,
        depth: 0,
        flowDischarge: 0,
      ),

      //SIGNIN PAGE WITH 3 TEXT FIELD CONTROLLERS
      // home: Signin(
      //   email: controller1,
      //   pwd: controller2,
      //   confirmpwd: controller3,
      // ),

      //LOGIN PAGE WITH 2 TEXTFIELD CONTROLLERS
      // home: LogIn(email: controller1, password:controller2,),
    );
  }
}
