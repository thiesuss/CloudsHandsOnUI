import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_file.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loginStateWidget.dart';
// import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();


  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginStateWidget());
  }
}
