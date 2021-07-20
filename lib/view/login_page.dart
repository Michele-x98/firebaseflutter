import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/services/local_notification_service.dart';
import 'package:firebaseflutter/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoginPage extends StatefulWidget {
  late final Function animate;
  LoginPage(Function animateTo, {Key? key}) {
    this.animate = animateTo;
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login'),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  validator: (v) {},
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ),
              Container(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (v) => validetePassword(v),
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.animate(1);
                },
                child: Text('Create an account'),
              ),
              ElevatedButton(onPressed: () => login(), child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }

  String? validetePassword(String? password) {
    if (password!.isEmpty && password.length < 4 || password.length > 12) {
      return 'Error, password incorrect';
    }
    return null;
  }

  Future<UserCredential?> registration() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  login() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
            builder: (context) => HomePage(),
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
}
