import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<ApiResult<Map<String, dynamic>>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          //api currently do not alwasy send a json back dont want to cause a failure error
          //when the response was still successfull
          if (response.body.isEmpty) {
            return ApiResult.success({});
          }
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          return ApiResult.success(jsonData);
        } catch (e) {
          return ApiResult.success({});
        }
      } else {
        return ApiResult.error(
          'Error ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return ApiResult.error('Failed to connect to the server: $e');
    }
  }
}

/// API Wraper
class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult({this.data, this.error});

  // Factory for success
  factory ApiResult.success(T data) {
    return ApiResult(data: data);
  }

  // Factory for error
  factory ApiResult.error(String error) {
    return ApiResult(error: error);
  }

  bool get isSuccess => data != null;
}
