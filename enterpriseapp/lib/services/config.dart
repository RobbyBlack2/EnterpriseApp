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
        return ApiResult.error('Invalid Response Format');
      }
    } else {
      if (result.statusCode == 401) {
        return ApiResult.error('Invalid System ID or Password');
      } else if (result.statusCode == 400) {
        return ApiResult.error('Invalid Request');
      } else if (result.statusCode == 500) {
        return ApiResult.error('Unknown Server Error, Please Try Again');
      }
      return ApiResult.error(result.error!);
    }
  }
}
