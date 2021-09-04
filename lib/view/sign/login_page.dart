import 'package:firebaseflutter/controller/signX_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SignXController lx = Get.find();
    return Obx(
      () => Container(
        margin: EdgeInsets.all(30),
        alignment: AlignmentDirectional.topCenter,
        height: 400,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 350, maxHeight: 500),
          child: Form(
            key: lx.loginFormKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: lx.emailController,
                    validator: (v) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: 'Email',
                      filled: true,
                      prefixIcon: Icon(
                        Icons.account_circle,
                        size: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: lx.showPassword.value,
                    controller: lx.passwordController,
                    validator: lx.validatePassword,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: 'Password',
                      prefixIcon: Icon(
                        CupertinoIcons.lock_fill,
                        size: 25,
                      ),
                      errorText: null,
                      suffixIcon: IconButton(
                        onPressed: () =>
                            lx.showPassword.value = !lx.showPassword.value,
                        icon: lx.showPassword.value
                            ? Icon(Icons.visibility_outlined)
                            : Icon(Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AnimatedContainer(
                    height: lx.onLogin.value ? 0 : null,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    child: lx.onLogin.value
                        ? Container()
                        : TextFormField(
                            obscureText: lx.showPassword.value,
                            controller: lx.confirmPasswordController,
                            validator: lx.validatePassword,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              labelText: 'Conferma Password',
                              prefixIcon: Icon(
                                CupertinoIcons.lock_fill,
                                size: 25,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => lx.showPassword.value =
                                    !lx.showPassword.value,
                                icon: lx.showPassword.value
                                    ? Icon(Icons.visibility_outlined)
                                    : Icon(Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                  ),
                  TextButton(
                    onPressed: () {
                      lx.animateToPage(1);
                    },
                    child: Text('Forgot Password'),
                  ),
                  ElevatedButton(
                    onPressed:
                        lx.onLogin.value ? () => lx.login() : () => lx.signIn(),
                    child: Text(lx.onLogin.value ? 'LOGIN' : 'REGISTRATI'),
                  ),
                  TextButton(
                      onPressed: () => lx.onLogin.value = !lx.onLogin.value,
                      child: Text(lx.onLogin.value ? 'REGISTRATI' : 'LOGIN'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
