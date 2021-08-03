import 'package:firebaseflutter/view/home_page.dart';
import 'package:firebaseflutter/view/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

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
              height: 400,
              child: pages,
            ),
            TextButton(
              onPressed: () => Get.offAll(Home()),
              child: Text('skip'),
            )
          ],
        ),
      ),
    );
  }
}
