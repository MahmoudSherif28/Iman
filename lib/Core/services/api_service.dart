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
      print('[API_SERVICE] Making HTTP request to: $url');
      final uri = Uri.parse(url);

      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // دمج الرؤوس المخصصة مع الافتراضية
      final requestHeaders = {...defaultHeaders, ...?headers};

      print('[API_SERVICE] Request headers: $requestHeaders');
      
      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: timeoutSeconds));

      print('[API_SERVICE] Response status: ${response.statusCode}');
      print('[API_SERVICE] Response body length: ${response.body.length}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);
          print('[API_SERVICE] Successfully parsed JSON response');
          return data as Map<String, dynamic>;
        } catch (e) {
          print('[API_SERVICE] JSON parsing error: $e');
          throw ServerFailure.fromHttpException(e);
        }
      } else {
        print('[API_SERVICE] HTTP error: ${response.statusCode} - ${response.body}');
        throw ServerFailure.fromResponse(response.statusCode, response.body);
      }
    } catch (e) {
      print('[API_SERVICE] Exception during HTTP request: $e');
      if (e is ServerFailure) {
        rethrow;
      } else {
        throw ServerFailure.fromHttpException(e);
      }
    }
  }
}
