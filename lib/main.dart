import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseflutter/services/badge_handler_service.dart';
import 'package:firebaseflutter/services/my_provider.dart';
import 'package:firebaseflutter/services/local_notification_service.dart';
import 'package:firebaseflutter/services/push_notifcation_service.dart';
import 'package:firebaseflutter/view/home_page.dart';
import 'package:firebaseflutter/view/sign_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

// Recive message when app is in background or terminated
Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);

  var badgeHandler = new BadgeCounterHandler();

  if (Platform.isAndroid) {
    print('Background notification recived on Andorid');
    var isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (isSupported) {
      badgeHandler.incrementAppBadgeCounter();
    }
  } else {
    badgeHandler.analyzeAppleNotification(message.notification!.apple!);
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

    FlutterAppBadger.removeBadge();

    LocalNotificationService.initialize();
    Get.put(Controller());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AsyncCubit(),
        ),
        Provider<PushNotificationService>(
          create: (context) => PushNotificationService(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => MyProvider(),
        )
      ],
      child: GetMaterialApp(
        home: MaterialApp(
          home: SignPage(),
        ),
      ),
    );
  }
}
