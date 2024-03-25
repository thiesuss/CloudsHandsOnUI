import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/dashboard.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.loginState);
  LoginState loginState;

  @override
  State<LoginPage> createState() => _LoginPageState(this.loginState);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState(this.loginState);
  LoginState loginState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TextButton(
        child: Text('Login'),
        onPressed: () {
          (loginState as LoggedOutState).login("", "");
        },
      ),
    ));
  }
}
