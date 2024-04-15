import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/services/employeeservice.dart';
import 'package:meowmed/data/states/login/awsKeyAuth.dart';
import 'package:meowmed/data/states/login/azureKeyAuth.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/dashboard.dart';
import 'package:openapi/api.dart';
import 'package:http/http.dart' as http;

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
            Card(
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // TODO: Extract Logo
                    Container(
                      width: 350,
                      height: 50,
                      child: Image(
                        image: AssetImage(
                            'assets/images/MeowcroservicesLogoNew.png'),
                      ),
                    ),
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
                        : ElevatedButton(
                            onPressed: _login,
                            child: Text('Login'),
                          ),
                  ],
                ),
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

    // Construct your authentication request
    final Map<String, dynamic> authData = {
      'grant_type': 'password',
      'client_id': '1mca5mnteu171qjom85iie7ij7',
      'username': username,
      'password': password,
    };

    final String userPoolURL = 'https://cognito-idp.eu-central-1.amazonaws.com/eu-central-1_N3VD2ejUL/oauth2/token';

    final Uri tokenEndpoint = Uri.parse(userPoolURL);

    try {
      final response = await http.post(
        tokenEndpoint,
        body: authData,
      );

      // Parse the response
      final responseData = json.decode(response.body);
      // Handle the response accordingly
    } catch (error) {
      setState(() {
        _errorMessage = 'Authentication failed: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _passwordController.clear();
    }
  }
}
