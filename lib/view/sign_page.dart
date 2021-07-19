import 'package:firebaseflutter/provider/sign_provider.dart';
import 'package:firebaseflutter/view/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class SignPage extends StatefulWidget {
  SignPage({Key? key}) : super(key: key);

  @override
  SignPageState createState() => SignPageState();
}

class SignPageState extends State<SignPage> {
  @override
  Widget build(BuildContext context) {
    final pages = new PageView(
      controller: context.read<SignProvider>().controller,
      physics: new NeverScrollableScrollPhysics(),
      children: [
        LoginPage(),
        RegistrationPage(),
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
