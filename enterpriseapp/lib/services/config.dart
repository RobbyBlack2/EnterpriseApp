import 'package:enterpriseapp/data/dto/config.dart';
import 'package:enterpriseapp/models/config.dart';
import 'package:enterpriseapp/services/api.dart';

class ConfigService {
  final ApiService _apiService;

  ConfigService(this._apiService);

  Future<ApiResult<Config>> fetchConfig(
    String systemId,
    String password,
    String url,
  ) async {
    final fullUrl = 'https://$url/login/api-enterprise.php';
    // Make the API call
    final result = await _apiService.post(fullUrl, {
      'request': 'getconfigjson',
      'systemid': systemId,
      'password': password,
    });
    //print(result.data);

    // Process the result
    if (result.isSuccess) {
      try {
        // Map the raw JSON to ConfigDTO and then to ConfigModel
        final dto = ConfigDTO.fromJson(result.data!);
        Config? config = dto.toModel();
        return ApiResult.success(config);
      } catch (e) {
        return ApiResult.error('Failed to process the response: $e');
      }
    } else {
      return ApiResult.error(result.error!);
    }
  }
}
