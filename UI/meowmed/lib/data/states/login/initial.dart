import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/data/states/state.dart';

class LoginStateInitial implements LoginState {
  LoginStateInitial(this._loginStateContext) {}
  LoginStateContext _loginStateContext;

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
    final state = LoggedOutState(_loginStateContext);
    await nextState(state);
  }

  @override
  Future<LoginState> nextState(LoginState state) async {
    await this.dispose();
    _loginStateContext.state.add(state);
    state.init();
    return state;
  }
}
