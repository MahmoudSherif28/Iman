import 'package:geolocator/geolocator.dart';
import 'package:iman/Core/errors/location_excaption.dart';
import 'package:iman/Features/qibla/data/models/location_model.dart';
import 'package:iman/Features/qibla/data/repos/location%20repos/location_repo.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException(
          'خدمة الموقع غير مفعلة',
          LocationErrorType.serviceDisabled,
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          'تم رفض صلاحيات الموقع بشكل دائم',
          LocationErrorType.permissionDeniedForever,
        );
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(
            'تم رفض صلاحيات الموقع',
            LocationErrorType.permissionDenied,
          );
        }
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LocationModel.fromPosition(position);
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException(
        'حدث خطأ غير متوقع: $e',
        LocationErrorType.unknown,
      );
    }
  }

  @override
  Future<LocationModel?> getLastKnownLocation() async {
    try {
      final Position? position = await Geolocator.getLastKnownPosition();
      return position != null ? LocationModel.fromPosition(position) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  @override
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  @override
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }
}
