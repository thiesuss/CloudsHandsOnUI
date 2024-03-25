import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/data/states/state.dart';
import 'package:meowmed/screens/dashboard.dart';
import 'package:openapi/api.dart';

class LoggedInState implements LoginState {
  final CachedObj<EmployeeRes> employee;
  LoginStateContext _loginStateContext;
  StreamSubscription? _employeeSubscription;
  LoggedInState(this._loginStateContext, this.employee) {}

  Future<LoginState> logout() async {
    final state = LoggedOutState(_loginStateContext);
    return nextState(state);
  }

  @override
  Widget getWidget() {
    return Dashboard();
  }

  @override
  Future<void> dispose() async {
    await _employeeSubscription?.cancel();
  }

  @override
  Future<void> init() async {
    _employeeSubscription = _loginStateContext.state.listen((state) {
      if (employee.isDeleted()) {
        this.dispose();
        final state = LoggedOutState(_loginStateContext);
        _loginStateContext.state.add(state);
      }
    });
  }

  @override
  Future<LoginState> nextState(LoginState state) async {
    await this.dispose();
    _loginStateContext.state.add(state);
    state.init();
    return state;
  }
}
