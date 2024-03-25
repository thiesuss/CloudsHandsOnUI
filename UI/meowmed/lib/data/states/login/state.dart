import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/service.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/state.dart';

abstract class LoginState implements AppState, StatefullObj {
  LoginState(this._loginStateContext);
  final LoginStateContext _loginStateContext;
  Future<void> nextState(LoginState state);
  Widget getWidget();
}
