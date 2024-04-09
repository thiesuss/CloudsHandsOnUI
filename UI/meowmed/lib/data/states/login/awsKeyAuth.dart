import 'package:openapi/api.dart';

class AwsKeyAuth implements Authentication {
  AwsKeyAuth(this.apiKey);

  String apiKey;

  @override
  Future<void> applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) {
    headerParams["X-Api-Key"] = apiKey;
    return Future.value();
  }
}