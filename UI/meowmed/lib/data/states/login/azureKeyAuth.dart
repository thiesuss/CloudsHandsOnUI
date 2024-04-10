import 'package:openapi/api.dart';

class AzureKeyAuth implements Authentication {
  AzureKeyAuth(this.apiKey);

  String apiKey;

  @override
  Future<void> applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) {
    headerParams["Ocp-Apim-Subscription-Key"] = apiKey;
    return Future.value();
  }
}
