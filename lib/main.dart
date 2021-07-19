import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseflutter/view/sign_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

// Recive message when app is in background
Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Inizializzo firebase app
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Text('ERROR'),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return SignPage();
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
