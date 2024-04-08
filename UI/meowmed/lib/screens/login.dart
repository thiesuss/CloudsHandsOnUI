import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/services/employeeservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/dashboard.dart';
import 'package:openapi/api.dart';

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
                width: 400,
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
    // TODO: remove
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String backendUrl = backendUrlController.text;
    switch (backendUrl) {
      case 'aws':
        backendUrl =
            'https://m1yubp2lxf.execute-api.eu-central-1.amazonaws.com/Stage1';
        break;
      case 'azure':
        backendUrl = 'https://meowmedazure-functions.azurewebsites.net/api';
        break;
      case 'azure1':
        backendUrl = 'https://meowmedazure-apim.azure-api.net/';
        break;
      default:
        backendUrl = "http://mock:8080";
    }

    backendUrlController.text = backendUrl;

    String filteredURL = backendUrl;
    if (backendUrl.endsWith("/")) {
      filteredURL = backendUrl.substring(0, backendUrl.length - 1);
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
      final backendUri = Uri.parse(filteredURL);
      await loggedOutState.login(username, password, backendUri);
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
