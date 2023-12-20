import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_resources/Pages/notify.dart';
import 'package:water_resources/navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyC8i5uEskZAFEzcHwQB-l1jsh2vWJWPVso",
            appId: "1:803289000101:android:cd304cd794d0ab7819054c",
            messagingSenderId: "803289000101",
            projectId: "waterproject-8c1a3",
          ),
        )
      : await Firebase.initializeApp();
  await AndroidAlarmManager.initialize();

  await LocalNotification.init();
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), 1, backgroundFunction);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screen(),
    );
  }
}
