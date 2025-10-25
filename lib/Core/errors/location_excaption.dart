enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  unknown,
}

class LocationException implements Exception {
  final String message;
  final LocationErrorType type;

  LocationException(this.message, this.type);

  @override
  String toString() => 'LocationException: $message';

  String get userMessage {
    switch (type) {
      case LocationErrorType.serviceDisabled:
        return 'يرجى تفعيل خدمات الموقع (GPS)';
      case LocationErrorType.permissionDenied:
        return 'يرجى السماح للتطبيق بالوصول إلى موقعك';
      case LocationErrorType.permissionDeniedForever:
        return 'يرجى تفعيل صلاحية الموقع من إعدادات التطبيق';
      case LocationErrorType.timeout:
        return 'انتهت مهلة الانتظار';
      case LocationErrorType.unknown:
        return 'حدث خطأ في الحصول على موقعك';
    }
  }

  bool get requiresSettings {
    return type == LocationErrorType.serviceDisabled ||
        type == LocationErrorType.permissionDeniedForever;
  }
}
