import 'package:firebaseflutter/provider/sign_provider.dart';
import 'package:firebaseflutter/view/sign_page.dart';
import 'package:firebaseflutter/view/login_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
