import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  late final Function animateTo;
  RegistrationPage(Function function, {Key? key}) {
    this.animateTo = function;
  }

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
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
              Text('SignIn'),
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
              Container(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (v) => validetePassword(v),
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.animateTo(0);
                },
                child: Text('Login'),
              ),
              ElevatedButton(onPressed: () => signIn(), child: Text('SignIn')),
            ],
          ),
        ),
      ),
    );
  }

  signIn() async {
    User? _user;
    if (!_formKey.currentState!.validate()) return;
    if (_confirmPasswordController.text
            .toLowerCase()
            .compareTo(_passwordController.text.toLowerCase()) !=
        0) return;
    try {
      UserCredential res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      _user = res.user;
      print('ciao');
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    print("Created user with email: ${_user?.email}");
    Future.delayed(
      Duration(seconds: 3),
      () => widget.animateTo(0),
    );
  }

  String? validetePassword(String? password) {
    if (password!.isEmpty && password.length < 6 || password.length > 12) {
      return 'Error, password incorrect';
    }
    return null;
  }
}
