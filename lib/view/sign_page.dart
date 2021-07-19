import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseflutter/view/home_page.dart';
import 'package:firebaseflutter/view/registration_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class SignPage extends StatefulWidget {
  SignPage({Key? key}) : super(key: key);

  @override
  SignPageState createState() => SignPageState();
}

class SignPageState extends State<SignPage> {
  final PageController controller = new PageController();

  void animateToPage(int index) {
    controller.animateToPage(index,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }

  Future req(FirebaseMessaging messaging) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
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

  @override
  void initState() {
    super.initState();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    req(messaging);
    // When user TAP on notification when app is TERMINATED
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false);
      }
    });

    // Only for notification when app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title);
      print(message.notification!.body);
    });

    // When user TAP on notification when app is OPENED but in BACKGOUND
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      print(routeFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = new PageView(
      controller: controller,
      physics: new NeverScrollableScrollPhysics(),
      children: [
        LoginPage(animateToPage),
        RegistrationPage(animateToPage),
      ],
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 100,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width,
              child: pages,
            )
          ],
        ),
      ),
    );
  }
}
