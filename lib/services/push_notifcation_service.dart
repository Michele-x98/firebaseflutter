import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseflutter/services/local_notification_service.dart';

class PushNotificationService {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  List<String> _topicSubscribed = [];

  FirebaseMessaging get messagingInstance => _messaging;

  PushNotificationService() {
    print('PushNotificationService costructor lunched');
    if (Platform.isIOS) {
      print('request ios permission');
      //Check ios permission
      _iosRequestPermissionAndForegroundNotification(_messaging);
    }

    //Subscrive to topic
    subscribeToTopic('noti');

    // Listen on user TAP on notification when app is TERMINATED
    _messaging.getInitialMessage().then((message) {
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

  // PUBLIC METHOD
  void unsubscribeToTopic(String topic) async {
    if (_topicSubscribed.contains(topic)) {
      await this._messaging.unsubscribeFromTopic(topic);
      _topicSubscribed.remove(topic);
      print('succesful unsubscribe to topic: $topic');
    } else {
      print('Error, you are not already subscribed to topic: $topic');
    }
  }

  void subscribeToTopic(String topic) async {
    await this._messaging.subscribeToTopic(topic);
    _topicSubscribed.add(topic);
    print('succesful subscribe to topic: $topic');
  }

  // PRIVATE METHOD
  Future _iosRequestPermissionAndForegroundNotification(
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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
