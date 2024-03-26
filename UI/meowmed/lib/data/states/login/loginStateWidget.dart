import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/state.dart';

class LoginStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: LoginStateContext.getInstance().stateStream,
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
