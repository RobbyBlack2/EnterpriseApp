import 'dart:convert';
import 'dart:io';
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
          return ApiResult.success(jsonData, statusCode: response.statusCode);
        } catch (e) {
          return ApiResult.success({});
        }
      } else {
        //error will be overriten or def to error
        return ApiResult.error(
          'Unknown Error ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return ApiResult.error(
        'Error: No Internet Connection or Invalid Domain',
        statusCode: null,
      );
    } on FormatException {
      return ApiResult.error('Invalid Domain Entered', statusCode: null);
    } catch (e) {
      return ApiResult.error('Unknown error occurred ', statusCode: null);
    }
  }
}

/// API Wraper
class ApiResult<T> {
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResult({this.data, this.error, this.statusCode});

  factory ApiResult.success(T data, {int? statusCode}) {
    return ApiResult(data: data, statusCode: statusCode);
  }

  factory ApiResult.error(String error, {int? statusCode}) {
    return ApiResult(error: error, statusCode: statusCode);
  }

  bool get isSuccess => data != null;
}
