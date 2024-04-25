
import 'package:internalapi/api.dart';

class AzureKeyAuth implements Authentication {
  AzureKeyAuth(this.apiKey);

  String apiKey;

  @override
  Future<void> applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) {
    headerParams["Authorization"] = apiKey;
    return Future.value();
  }
}
