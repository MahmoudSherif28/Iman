import 'package:geolocator/geolocator.dart';
import 'package:iman/Core/errors/location_excaption.dart';
import 'package:iman/Features/qibla/data/models/location_model.dart';
import 'package:iman/Features/qibla/data/repos/location%20repos/location_repo.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      print('[LOCATION_REPO] Checking if location service is enabled...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('[LOCATION_REPO] Location service enabled: $serviceEnabled');
      
      if (!serviceEnabled) {
        print('[LOCATION_REPO] Location service is disabled');
        throw LocationException(
          'خدمة الموقع غير مفعلة',
          LocationErrorType.serviceDisabled,
        );
      }

      print('[LOCATION_REPO] Checking location permissions...');
      LocationPermission permission = await Geolocator.checkPermission();
      print('[LOCATION_REPO] Current permission status: $permission');

      if (permission == LocationPermission.deniedForever) {
        print('[LOCATION_REPO] Permission denied forever');
        throw LocationException(
          'تم رفض صلاحيات الموقع بشكل دائم',
          LocationErrorType.permissionDeniedForever,
        );
      }

      if (permission == LocationPermission.denied) {
        print('[LOCATION_REPO] Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
        print('[LOCATION_REPO] Permission after request: $permission');
        
        if (permission == LocationPermission.denied) {
          print('[LOCATION_REPO] Permission still denied after request');
          throw LocationException(
            'تم رفض صلاحيات الموقع',
            LocationErrorType.permissionDenied,
          );
        }
      }

      print('[LOCATION_REPO] Getting current position...');
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      print('[LOCATION_REPO] Got position: ${position.latitude}, ${position.longitude}');

      return LocationModel.fromPosition(position);
    } on LocationException {
      print('[LOCATION_REPO] LocationException occurred, rethrowing...');
      rethrow;
    } catch (e) {
      print('[LOCATION_REPO] Unexpected exception: $e');
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
