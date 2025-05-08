import 'package:enterpriseapp/core/constants/constants.dart';
import 'package:enterpriseapp/models/session.dart';
import 'package:enterpriseapp/services/api.dart';
import 'package:enterpriseapp/services/localstorage.dart';

class SessionService {
  final _apiService = ApiService(baseUrl: Constants.baseUrl);
  final _localStorage = LocalStorage();
  SessionService();

  Future<ApiResult<void>> submitSesison(Session session) async {
    String? systemid = await _localStorage.getSystemid();
    String? password = await _localStorage.getPassword();
    String? url = await _localStorage.getApiUrl();
    if (systemid == null || password == null || url == null) {
      return ApiResult.error('Invalid Credentials');
    }
    final fullUrl = 'https://$url/login/api-enterprise.php';
    //add system id request and pwd to body
    final payload = {
      'request': 'insert',
      'systemid': systemid,
      'password': password,
      ...session.toJson(),
    };

    final result = await _apiService.post(fullUrl, payload);

    // Process the result
    if (result.isSuccess) {
      return ApiResult.success(null);
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
