import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  static void initialize() {
    final InitializationSettings initializationSettings =
        new InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // To display notification banner when ADNROID app is in foreground
  static void displayAndroidNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = new NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id channel
          'High Importance Notifications', // title channel
          'This channel is used for important notifications.', // description channel
          priority: Priority.high,
          importance: Importance.max,
        ),
      );
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
