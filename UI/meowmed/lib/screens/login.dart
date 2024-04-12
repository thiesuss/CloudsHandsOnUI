import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/widgets/garten.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final backendUrlController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // TODO: Extract Logo
                  logo,
                  SizedBox(height: kDefaultMargin),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'user',
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'pass',
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Url bitte eingeben';
                      }
                      try {
                        Uri.parse(value);
                      } catch (e) {
                        return 'Ungültige Url';
                      }
                      return null;
                    },
                    controller: backendUrlController,
                    decoration: InputDecoration(
                      hintText: 'aws, azure, mock, eigene Url',
                      labelText: 'Backend Url',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(_errorMessage,
                          style: TextStyle(color: Colors.red)),
                    ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : TextButton(
                          onPressed: _login,
                          child: Text('Login'),
                        ),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    final loggedOutState =
        LoginStateContext.getInstance().state as LoggedOutState;

    //TODO: remove, this is just there,
    // so the user can see what url was chosen
    await Future.delayed(Duration(seconds: 1), () {});

    try {
      await loggedOutState.login(username, password, backendUrlController.text);
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _passwordController.clear();
    }
  }
}
