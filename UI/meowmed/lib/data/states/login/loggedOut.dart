import 'package:flutter/src/widgets/framework.dart';
import 'package:meowmed/data/exeptions/loginError.dart';
import 'package:meowmed/data/exeptions/timeout.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/services/employeeservice.dart';
import 'package:meowmed/data/services/mock.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/login.dart';
import 'package:openapi/api.dart';

class LoggedOutState implements LoginState {
  LoggedOutState() {}

  Future<LoginState> login(
      String username, String password, Uri backendUri) async {
    //START MOCK
    String id = "ID1234567890";
    // final EmployeeRes employee = EmployeeRes(
    //     id: id,
    //     firstName: "John",
    //     lastName: "Doe",
    //     address: Address(
    //         street: "Limmerstr",
    //         houseNumber: "1",
    //         zipCode: 30519,
    //         city: "Hannover"));
    //END MOCK

    ApiClient client = ApiClient(basePath: backendUri.toString());
    final contractService = ContractService(client);
    final customerService = CustomerService(client);
    // final employeeService = EmployeeService(client);

    // final cachedObj = CachedObj<EmployeeRes>(id, employee);
    final state = LoggedInState(
        client, contractService, customerService);

    // TODO: remove
    final url = client.basePath;
    if (url == "http://localhost:8080") {
      await MockService().mock(state);
    }

    await nextState(state);

    // throw WrongCredentialsException();
    return state;
  }

  Widget getWidget() {
    return LoginPage();
  }

  @override
  Future<void> dispose() {
    return Future.value();
  }

  @override
  Future<void> init() {
    return Future.value();
  }

  @override
  Future<void> nextState(LoginState state) async {
    await this.dispose();
    await LoginStateContext.getInstance().notifyOfStateChange(state);
  }
}
