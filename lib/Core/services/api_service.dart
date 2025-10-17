import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iman/Core/errors/failure.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<Map<String, dynamic>> get(
    String url, {
    int timeoutSeconds = 10,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);

      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // دمج الرؤوس المخصصة مع الافتراضية
      final requestHeaders = {...defaultHeaders, ...?headers};

      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);
          return data as Map<String, dynamic>;
        } catch (e) {
          throw ServerFailure.fromHttpException(e);
        }
      } else {
        throw ServerFailure.fromResponse(response.statusCode, response.body);
      }
    } catch (e) {
      if (e is ServerFailure) {
        rethrow;
      } else {
        throw ServerFailure.fromHttpException(e);
      }
    }
  }
}
