import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:iman/Core/errors/failure.dart';

/// Singleton HTTP client wrapper for making API requests.
class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  /// Performs a GET request to the given [url] and returns the parsed JSON response.
  ///
  /// Throws [ServerFailure] on HTTP or parsing errors.
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

      final requestHeaders = {...defaultHeaders, ...?headers};

      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);
          return data as Map<String, dynamic>;
        } catch (e) {
          debugPrint('[ApiService] JSON parsing error: $e');
          throw ServerFailure.fromHttpException(e);
        }
      } else {
        debugPrint('[ApiService] HTTP error: ${response.statusCode}');
        throw ServerFailure.fromResponse(response.statusCode, response.body);
      }
    } catch (e) {
      if (e is ServerFailure) rethrow;
      debugPrint('[ApiService] Request failed: $e');
      throw ServerFailure.fromHttpException(e);
    }
  }
}
