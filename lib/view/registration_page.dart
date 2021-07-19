import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/provider/sign_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key}) : super(key: key);

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
                  context.read<SignProvider>().controller.animateToPage(0,
                      duration: Duration(seconds: 1), curve: Curves.ease);
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
        () => context.read<SignProvider>().controller.animateToPage(0,
            duration: Duration(seconds: 1), curve: Curves.ease));
  }

  String? validetePassword(String? password) {
    if (password!.isEmpty && password.length < 6 || password.length > 12) {
      return 'Error, password incorrect';
    }
    return null;
  }
}
