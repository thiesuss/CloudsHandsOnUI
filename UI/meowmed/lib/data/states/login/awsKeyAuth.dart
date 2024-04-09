import 'package:openapi/api.dart';

class AwsKeyAuth implements Authentication {
  AwsKeyAuth(this.apiKey);

  String apiKey;

  @override
  Future<void> applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) async {
    headerParams["X-Api-Key"] = apiKey;
    // headerParams["Host"] = "m1yubp2lxf.execute-api.eu-central-1.amazonaws.com";
  }
}
