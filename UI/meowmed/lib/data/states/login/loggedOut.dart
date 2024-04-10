import 'package:flutter/material.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/services/mock.dart';
import 'package:meowmed/data/states/login/awsKeyAuth.dart';
import 'package:meowmed/data/states/login/azureKeyAuth.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/login.dart';
import 'package:openapi/api.dart';

enum BackendType { aws, azure, azure1, mock }

class LoggedOutState implements LoginState {
  LoggedOutState() {}

  static ApiClient getApiClientFromData(
      String username, String password, String backendUrl) {
    String authKey;
    Authentication? auth;
    BackendType? backendType;

    switch (backendUrl) {
      case 'aws':
        backendUrl =
            'http://ec2-18-159-254-31.eu-central-1.compute.amazonaws.com:8081/v1';
        authKey = "zMvbvu4RjkaOof38EPgYU9RIZuCRDfEi7oGFqcyv";
        auth = AwsKeyAuth(authKey);
        backendType = BackendType.aws;
        break;
      case 'azure':
        backendUrl = 'https://meowmedazure-functions.azurewebsites.net/api';
        authKey = "c8d3600efbf74bf0981a157bd412945b";
        auth = AzureKeyAuth(authKey);
        backendType = BackendType.azure;
        break;
      case 'azure1':
        backendUrl = 'https://meowmedazure-apim.azure-api.net/';
        authKey = "c8d3600efbf74bf0981a157bd412945b";
        auth = AzureKeyAuth(authKey);
        backendType = BackendType.azure;
        break;
      case '':
        backendUrl = "http://mock:8080";
        backendType = BackendType.mock;
      default:
        break;
    }

    String filteredURL = backendUrl;

    if (backendUrl.endsWith("/")) {
      filteredURL = backendUrl.substring(0, backendUrl.length - 1);
    }
    final backendUri = Uri.parse(filteredURL);
    final client =
        ApiClient(basePath: backendUri.toString(), authentication: auth);


    return client;
  }

  Future<LoginState> login(
      String username, String password, String backendUrl) async {
    ApiClient client = getApiClientFromData(username, password, backendUrl);

    final contractService = ContractService(client);
    final customerService = CustomerService(client);
    final state = LoggedInState(client, contractService, customerService);
    final url = client.basePath;
    if (url == "http://mock:8080") await MockService().mock(state);
    await nextState(state);
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
