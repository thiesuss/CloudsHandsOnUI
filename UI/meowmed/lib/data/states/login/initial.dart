import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/data/states/login/state.dart';

class LoginStateInitial implements LoginState {
  LoginStateInitial() {
  }

  @override
  Widget getWidget() {
    return Container(
        width: 100, height: 100, child: CircularProgressIndicator());
  }

  @override
  Future<void> dispose() {
    return Future.value();
  }

  @override
  Future<void> init() async {
    final state = LoggedOutState();
    await nextState(state);
  }

  @override
  Future<void> nextState(LoginState state) async {
    await this.dispose();
    await LoginStateContext.getInstance().notifyOfStateChange(state);
  }
}
