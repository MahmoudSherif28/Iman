import 'dart:math' as math;

import 'package:iman/Features/qibla/data/models/location_model.dart';
import 'package:iman/Features/qibla/data/repos/qiblah_calculator_repos/qiblah_calculator_repo.dart';

/// Concrete implementation of [QiblaCalculatorService] using the Haversine formula.
class QiblaCalculatorServiceImpl implements QiblaCalculatorService {
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  @override
  double calculateQiblaBearing(double userLatitude, double userLongitude) {
    if (userLatitude < -90 || userLatitude > 90) {
      throw ArgumentError('خط العرض يجب أن يكون بين -90 و 90');
    }
    if (userLongitude < -180 || userLongitude > 180) {
      throw ArgumentError('خط الطول يجب أن يكون بين -180 و 180');
    }

    final double lat1Rad = _degreesToRadians(userLatitude);
    final double lon1Rad = _degreesToRadians(userLongitude);
    final double lat2Rad = _degreesToRadians(kaabaLatitude);
    final double lon2Rad = _degreesToRadians(kaabaLongitude);

    final double deltaLon = lon2Rad - lon1Rad;

    final double x = math.cos(lat2Rad) * math.sin(deltaLon);
    final double y =
        math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(deltaLon);

    double bearing = math.atan2(x, y);
    bearing = _radiansToDegrees(bearing);
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  @override
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  @override
  double distanceToKaaba(double userLat, double userLon) {
    return calculateDistance(userLat, userLon, kaabaLatitude, kaabaLongitude);
  }

  @override
  QiblaInfo getQiblaInfo(LocationModel userLocation) {
    return QiblaInfo(
      qiblaBearing: calculateQiblaBearing(
        userLocation.latitude,
        userLocation.longitude,
      ),
      distanceToKaaba: distanceToKaaba(
        userLocation.latitude,
        userLocation.longitude,
      ),
      userLocation: userLocation,
    );
  }

  @override
  double angleDifference(double angle1, double angle2) {
    double diff = angle2 - angle1;

    // تطبيع للمجال -180 إلى 180
    while (diff > 180) {
      diff -= 360;
    }
    while (diff < -180) {
      diff += 360;
    }

    return diff;
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180.0;
  double _radiansToDegrees(double radians) => radians * 180.0 / math.pi;
}

