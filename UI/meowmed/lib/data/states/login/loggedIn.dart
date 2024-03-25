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
  StreamSubscription? _employeeSubscription;
  LoggedInState(this.employee) {}

  Future<void> logout() async {
    final state = LoggedOutState();
    await nextState(state);
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
    _employeeSubscription =
        LoginStateContext.getInstance().state.listen((state) {
      if (employee.isDeleted()) {
        this.dispose();
        final state = LoggedOutState();
        LoginStateContext.getInstance().notifyOfStateChange(state);
      }
    });
  }

  @override
  Future<void> nextState(LoginState state) async {
    await this.dispose();
    LoginStateContext.getInstance().notifyOfStateChange(state);
  }
}
