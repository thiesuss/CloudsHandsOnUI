import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/state.dart';

class LoginStateWidget extends StatefulWidget {
  LoginStateWidget({super.key, required this.loginStateContext});
  LoginStateContext loginStateContext;
  @override
  State<LoginStateWidget> createState() =>
      _LoginStateWidgetState(this.loginStateContext);
}

class _LoginStateWidgetState extends State<LoginStateWidget> {
  _LoginStateWidgetState(this.loginStateContext);
  LoginStateContext loginStateContext;

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = loginStateContext.state.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: loginStateContext.state,
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<LoginState?> snapshot) {
        if (!snapshot.hasData) {
          return Text("Not correctly initialized");
        }
        return Container(
          child: snapshot.data!.getWidget(),
        );
      },
    );
  }
}
