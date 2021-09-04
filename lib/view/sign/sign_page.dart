import 'package:firebaseflutter/controller/signX_controller.dart';
import 'package:firebaseflutter/view/home_page.dart';
import 'package:firebaseflutter/view/sign/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_page.dart';

class SignPage extends StatefulWidget {
  SignPage() {
    Get.put(SignXController());
  }

  @override
  SignPageState createState() => SignPageState();
}

class SignPageState extends State<SignPage> {
  @override
  Widget build(BuildContext context) {
    final pages = new PageView(
      controller: Get.find<SignXController>().controller,
      physics: new NeverScrollableScrollPhysics(),
      children: [
        LoginPage(),
        RegistrationPage(),
      ],
    );
    return Scaffold(
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 100,
            ),
            SizedBox(
              height: 511,
              child: pages,
            ),
            TextButton(
              onPressed: () => Get.offAll(HomeStream()),
              child: Text('skip'),
            )
          ],
        ),
      ),
    );
  }
}
