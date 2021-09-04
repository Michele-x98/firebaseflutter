import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/view/home_page.dart';
import 'package:firebaseflutter/view/notification_settings_page.dart';
import 'package:firebaseflutter/widgets/error_snackbar.dart';
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
      Get.offUntil(
        new MaterialPageRoute(
          builder: (context) => NotificationSettingsPage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorSnackbar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        errorSnackbar('Wrong password provided for that user.');
      }
      return;
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
      errorSnackbar(e.toString());
      return;
    }
    completeSnackbar('Created user with email: ${_user?.email}');
    Future.delayed(
      Duration(seconds: 3),
      () => Get.offUntil(
          new MaterialPageRoute(
            builder: (context) => NotificationSettingsPage(),
          ),
          (route) => false),
    );
  }

  String? validatePassword(String? password) {
    if (password!.isEmpty) {
      return 'Error, empty password';
    }

    if (password.length < 4 || password.length > 12) {
      return 'Error, password incorrect';
    }
    return null;
  }

  void animateToPage(int index) {
    controller.animateToPage(index,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }
}
