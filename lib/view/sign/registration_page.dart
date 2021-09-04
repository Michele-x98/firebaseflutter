import 'package:firebaseflutter/controller/signX_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage();

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    SignXController rx = Get.find();
    return Container(
      padding: EdgeInsets.all(30),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: rx.regFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SignIn'),
              Container(
                width: 300,
                child: TextFormField(
                  controller: rx.emailController,
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
                        controller: rx.passwordController,
                        obscureText: true,
                        validator: (v) => rx.validatePassword(v),
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: rx.confirmPasswordController,
                        obscureText: true,
                        validator: (v) => rx.validatePassword(v),
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  rx.animateToPage(0);
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () => rx.signIn(),
                child: Text('SignIn'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
