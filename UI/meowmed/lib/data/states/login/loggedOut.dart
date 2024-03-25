import 'package:flutter/src/widgets/framework.dart';
import 'package:meowmed/data/exeptions/loginError.dart';
import 'package:meowmed/data/exeptions/timeout.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/login.dart';
import 'package:openapi/api.dart';

class LoggedOutState implements LoginState {
  LoginStateContext _loginStateContext;

  LoggedOutState(this._loginStateContext) {}

  Future<LoginState> login(String username, String password) async {
    //START MOCK
    String id = "ID1234567890";
    final EmployeeRes employee = EmployeeRes(
        id: id,
        firstName: "John",
        lastName: "Doe",
        address: Address(
            street: "Limmerstr",
            houseNumber: "1",
            zipCode: 30519,
            city: "Hannover"));
    //END MOCK
    final cachedObj = CachedObj<EmployeeRes>(id, employee);
    final state = LoggedInState(_loginStateContext, cachedObj);
    await nextState(state);
    // throw WrongCredentialsException();
    // throw TimeoutException("a");
    return state;
  }

  @override
  Widget getWidget() {
    return LoginPage(this);
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
  Future<LoginState> nextState(LoginState state) async {
    await this.dispose();
    _loginStateContext.state.add(state);
    state.init();
    return state;
  }
}
