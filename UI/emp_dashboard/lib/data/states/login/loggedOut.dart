import 'package:flutter/material.dart';
import 'package:internalapi/api.dart';
import 'package:meowmed/data/services/applicationservice.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/states/login/awsKeyAuth.dart';
import 'package:meowmed/data/states/login/azureKeyAuth.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:meowmed/screens/login.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
// import 'package:dotenv/dotenv.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

enum BackendType { aws, azure, azure1, mock }
final navigatorKey =  GlobalKey<NavigatorState>();


class LoggedOutState implements LoginState {
  LoggedOutState() {}


  // static final Config config = Config(
  //   tenant: "e6ec6ab7-2331-40ca-b7bf-91f68aa466a1",
  //   clientId: "6caacece-1092-4719-b448-df3a9aaf1701",
  //   scope: "https://azuremeowmed.onmicrosoft.com/6caacece-1092-4719-b448-df3a9aaf1701",
  //   // redirectUri is Optional as a default is calculated based on app type/web location
  //   redirectUri: "https://happy-dune-0b8e1ec03.5.azurestaticapps.net/",
  //   navigatorKey: navigatorKey,
  //   webUseRedirect: true, // default is false - on web only, forces a redirect flow instead of popup auth
  //   //Optional parameter: Centered CircularProgressIndicator while rendering web page in WebView
  //   loader: Center(child: CircularProgressIndicator()),
  // );
  
  static final Config configB2Ca = Config(
    tenant: "azuremeowmed",
    clientId: "6caacece-1092-4719-b448-df3a9aaf1701",
    scope: "openid",
    redirectUri: "https://happy-dune-0b8e1ec03.5.azurestaticapps.net", // Note: this is the default for Mobile
    
    // clientSecret: dotenv.env['CLIENT_SECRET'], // Note: do not include secret in publicly available applications
    isB2C: true,
    policy: "B2C_1_azuremeowmedsigninonly",
    tokenIdentifier: "",
    navigatorKey: navigatorKey,
  );
  

  static Future<String?> azureB2CLogin() async{
    AadOAuth oauth = new AadOAuth(configB2Ca);
    final result = await oauth.login();
    String? accessToken = await oauth.getAccessToken();
    return accessToken;
  }

  static  Future<ApiClient> getApiClientFromData(
      String username, String password, String backendUrl) async {
    String authKey;
    Authentication? auth;
    BackendType? backendType;

    switch (backendUrl) {
      case 'aws':
        backendUrl =
            'https://a8hyu0e2ja.execute-api.eu-central-1.amazonaws.com/Stage/';
        authKey = "zMvbvu4RjkaOof38EPgYU9RIZuCRDfEi7oGFqcyv";
        auth = AwsKeyAuth(authKey);
        backendType = BackendType.aws;
        break;
      case 'azure':
        backendUrl = 'https://meowmedazure-apim.azure-api.net/internal/';
        authKey = "7b96905b26584158a16826123a9b394f";
        auth = AzureKeyAuth(authKey);
        backendType = BackendType.azure;
        break;
      case 'azure1':
        // AadOAuth oauth = new AadOAuth(configB2Ca);
        // final result = oauth.login();
        // String? accessToken = oauth.getAccessToken() as String?;
        // String at = accessToken ?? "";
        String at = "";
        try{
        await azureB2CLogin().then((value){
          at = value ?? "";
        });
        } catch (NotInitializedError) {
          break;
        }
        backendUrl = 'https://meowmedazure-apim.azure-api.net/internal/';
        authKey = at;
        auth = AzureKeyAuth("Bearer " + authKey);
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
    ApiClient client = await getApiClientFromData(username, password, backendUrl);

    final contractService = ContractService(client);
    final customerService = CustomerService(client);
    final applicationService = ApplicationService(client);
    final state = LoggedInState(
        client, contractService, customerService, applicationService);
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
