/// Types of location-related errors the app can encounter.
enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  unknown,
}

/// Exception thrown when a location operation fails.
class LocationException implements Exception {
  final String message;
  final LocationErrorType type;

  LocationException(this.message, this.type);

  @override
  String toString() => 'LocationException: $message';

  /// User-facing localised message for this error.
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

  /// Whether this error requires the user to open device/app settings.
  bool get requiresSettings {
    return type == LocationErrorType.serviceDisabled ||
        type == LocationErrorType.permissionDeniedForever;
  }
}

