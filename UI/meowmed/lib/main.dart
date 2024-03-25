import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loginStateWidget.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  LoginStateContext loginStateContext = LoginStateContext();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoginStateWidget(loginStateContext: loginStateContext));
  }
}
