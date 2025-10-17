import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

abstract class Failure {
  final String errorMessage;
  Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});

  factory ServerFailure.fromHttpException(Object error) {
    if (error is TimeoutException) {
      return ServerFailure(errorMessage: 'انتهت مهلة الاتصال بالخادم');
    }

    if (error is SocketException) {
      return ServerFailure(errorMessage: 'لا يوجد اتصال بالإنترنت');
    }

    if (error is http.ClientException) {
      final msg = error.message;
      if (msg.toLowerCase().contains('host lookup')) {
        return ServerFailure(errorMessage: 'تعذر العثور على اسم المضيف');
      }
      return ServerFailure(errorMessage: msg);
    }

    if (error is HttpException) {
      return ServerFailure(errorMessage: error.message);
    }

    if (error is FormatException) {
      return ServerFailure(errorMessage: 'تنسيق الاستجابة من الخادم غير صالح');
    }

    // أي استثناء آخر
    return ServerFailure(errorMessage: 'حدث خطأ غير متوقع، حاول مرة أخرى');
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic body) {
    dynamic responseBody = body;
    if (body is String) {
      try {
        responseBody = jsonDecode(body);
      } catch (_) {
        responseBody = {'message': body};
      }
    }

    String extractMessage(dynamic rb, {String fallback = 'حدث خطأ غير متوقع'}) {
      if (rb is Map && rb['message'] != null) return rb['message'].toString();
      return fallback;
    }

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      final msg = extractMessage(
        responseBody,
        fallback: 'طلب غير صالح أو ليس لديك صلاحية',
      );
      return ServerFailure(errorMessage: msg);
    } else if (statusCode == 404) {
      return ServerFailure(
        errorMessage: 'المحتوى المطلوب غير موجود. حاول لاحقاً',
      );
    } else if (statusCode == 422) {
      if (responseBody is Map<String, dynamic>) {
        final errorMessage = _parseValidationErrors(responseBody);
        return ServerFailure(errorMessage: errorMessage);
      }
      return ServerFailure(errorMessage: 'حدث خطأ في التحقق من البيانات (422)');
    } else if (statusCode == 500) {
      return ServerFailure(errorMessage: 'خطأ داخلي في الخادم. حاول لاحقاً');
    } else {
      final msg = extractMessage(responseBody, fallback: 'حدث خطأ غير متوقع');
      return ServerFailure(errorMessage: msg);
    }
  }

  static String _parseValidationErrors(Map<String, dynamic> response) {
    final buffer = StringBuffer();

    if (response.containsKey('errors') &&
        response['errors'] is Map<String, dynamic>) {
      final errors = response['errors'] as Map<String, dynamic>;

      errors.forEach((field, messages) {
        if (messages is List && messages.isNotEmpty) {
          for (final message in messages) {
            buffer.writeln(message.toString());
          }
        } else if (messages is String) {
          buffer.writeln(messages);
        }
      });
    }

    if (buffer.isEmpty) {
      buffer.write(
        response['message']?.toString() ??
            'خطأ في بيانات الإدخال. يرجى التحقق وإعادة المحاولة',
      );
    }

    return buffer.toString().trim();
  }
}
