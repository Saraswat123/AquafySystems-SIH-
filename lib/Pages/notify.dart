import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_resources/Pages/watercondition.dart';

final ref = FirebaseDatabase.instance.ref().child('waterProject');
double tds = 0;
double turbidity = 0;
double pH = 0;
bool isSafe = true;

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: ((id, title, body, payload) =>
                null));
    // final LinuxInitializationSettings initializationSettingsLinux =
    //     LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      // linux: initializationSettingsLinux
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: (details) {
      //   isNotified = false;
      // },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(0, 'Water Quality Alert!!!',
        'Water is not fit for drinking', notificationDetails,
        payload: 'item x');
  }

  static Future requestNotificationPermission() async {
    // Request permission for notifications
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<bool> areNotificationsEnabled() async {
    try {
      // Attempt to schedule a notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Notification ID
        'Test Notification',
        'This is a test notification',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id', // Replace with your channel ID
            'Your Channel Name', // Replace with your channel name
            channelDescription:
                'Your Channel Description', // Replace with your channel description
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          ),
        ),

        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      // Notification scheduling succeeded, meaning notifications are enabled
      return true;
    } catch (e) {
      // Notification scheduling failed, meaning notifications are disabled
      return false;
    }
  }
}

class DatabaseCollector {
  bool isNotified = false;

  Future<void> _databaseListener() async {
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
    ref.onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.value != null) {
        tds = double.parse(event.snapshot.child('TDS').value.toString());
        turbidity = double.parse(event.snapshot.child('Turb').value.toString());
        pH = double.parse(event.snapshot.child('ph').value.toString());
        waterQuality();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool notificationSent = prefs.getBool('notification_sent') ?? false;

        if (!isSafe && !notificationSent) {
          LocalNotification.showNotification();
          print('IsNotified set to true ---------------------------------');
          await prefs.setBool('notification_sent', true);
        }
        if (isSafe) {
          print('IsNotified set to false ---------------------------------');
          await prefs.setBool('notification_sent', false);
        }
      }
    }, onError: (Object error) {});
  }

  void waterQuality() {
    if ((tdsState(tds) == 3 || tdsState(tds) == 1 || tdsState(tds) == 4) &&
        turbidityState(turbidity) == 1 &&
        phState(pH) == 1) {
      isSafe = true;
      print(
          'Water is safe -----------------------------------------------------------------');
    } else {
      isSafe = false;
      print(
          'Water is not safe -----------------------------------------------------------------');
    }
  }
}

@pragma('vm:entry-point')
void backgroundFunction() {
  print("Alram working");
  DatabaseCollector()._databaseListener();
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  DatabaseCollector().isNotified = false;
  print('God you are great-----------------------');
}
