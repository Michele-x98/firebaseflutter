import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseflutter/services/local_notification_service.dart';
import 'package:firebaseflutter/view/notification_settings_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

// Recive message when app is in background or terminated
Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);

  if (Platform.isAndroid) {
    print('Background notification recived on Andorid');
    await FlutterAppBadger.isAppBadgeSupported().then(
      (value) => value ? FlutterAppBadger.updateBadgeCount(1) : null,
    );
  } else {
    FlutterAppBadger.updateBadgeCount(1);
    print('Background notification recived on iOS');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    //Request ios Permission
    if (Platform.isIOS) {
      print('request ios permission');
      iosRequestPermissionAndForegroundNotification(messaging);
    }

    subscribeToTopic(messaging);

    // Listen on user TAP on notification when app is TERMINATED
    messaging.getInitialMessage().then((message) {
      // DO SOMETHINGS
    });

    // Listen for RECIVE notification when app is in FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        LocalNotificationService.displayAndroidNotification(message);
        return;
      }
      // DO SOMETHINGS FOR IOS
    });

    // Listen on user TAP on notification when app is OPENED and in BACKGOUND
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // DO SOMETHINGS
      if (Platform.isAndroid) {
        print('App opened via notification on Andorid');
      } else {
        print('App opened via notification on iOS');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NotificationSettingsPage(),
      ),
    );
  }

  void subscribeToTopic(FirebaseMessaging messaging) async {
    String topic = 'noti';
    await messaging.subscribeToTopic(topic);
    print('subscribe to topic: $topic');
  }

  Future iosRequestPermissionAndForegroundNotification(
      FirebaseMessaging messaging) async {
    // Request permission for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // Allow foreground notifications for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // Allow foreground notifications for iOS
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
