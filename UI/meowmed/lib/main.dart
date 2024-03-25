import 'package:flutter/material.dart';
import 'package:meowmed/screens/customer.dart';
import 'package:meowmed/screens/dashboard.dart';
import 'package:meowmed/screens/newcontract.dart';
import 'package:meowmed/screens/newcustomer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Customer()
    );
  }
}
