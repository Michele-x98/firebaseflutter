import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/view/notification_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignXController extends GetxController {
  final PageController controller = new PageController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final regFormKey = GlobalKey<FormState>();
  RxBool showPassword = true.obs;
  RxBool emailOnFocus = true.obs;
  RxBool onLogin = true.obs;

  login() async {
    if (!loginFormKey.currentState!.validate()) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushAndRemoveUntil(
          Get.context!,
          new MaterialPageRoute(
            builder: (context) => NotificationSettingsPage(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  signIn() async {
    User? _user;
    if (!loginFormKey.currentState!.validate()) return;
    if (confirmPasswordController.text
            .toLowerCase()
            .compareTo(passwordController.text.toLowerCase()) !=
        0) return;
    try {
      UserCredential res =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      _user = res.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    // print("Created user with email: ${_user?.email}");
    Future.delayed(
      Duration(seconds: 3),
      () => animateToPage(0),
    );
  }

  String? validatePassword(String? password) {
    if (password != null) {
      if (password.isEmpty && password.length < 4 || password.length > 12) {
        return 'Error, password incorrect';
      }
      return 'Error, empty password';
    }
    return null;
  }

  void animateToPage(int index) {
    passwordController.clear();
    confirmPasswordController.clear();

    controller.animateToPage(index,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }
}
