import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:internalapi/api.dart';
import 'package:meowmed/data/services/applicationservice.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedOut.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/dashboard.dart';

class LoggedInState implements LoginState {
  // final CachedObj<EmployeeRes> employee;
  StreamSubscription? _employeeSubscription;
  LoggedInState(
      // this.employee,
      this.client,
      this.contractService,
      this.customerService,
      this.applicationService
      // this.employeeService,
      ) {}

  ApiClient client;
  late ContractService contractService;
  late CustomerService customerService;
  late ApplicationService applicationService;
  // late EmployeeService employeeService;

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
    // _employeeSubscription =
    //     LoginStateContext.getInstance().stateStream.listen((state) {
    // if (employee.isDeleted()) {
    //   this.dispose();
    //   final state = LoggedOutState();
    //   LoginStateContext.getInstance().notifyOfStateChange(state);
    // }
    // });
  }

  @override
  Future<void> nextState(LoginState state) async {
    await this.dispose();
    await LoginStateContext.getInstance().notifyOfStateChange(state);
  }
}
