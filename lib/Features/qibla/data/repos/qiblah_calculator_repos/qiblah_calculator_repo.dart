import 'package:iman/Features/qibla/data/models/location_model.dart';

/// Contract for Qibla direction calculation services.
abstract class QiblaCalculatorService {
  double calculateQiblaBearing(double userLatitude, double userLongitude);
  double calculateDistance(double lat1, double lon1, double lat2, double lon2);
  double distanceToKaaba(double userLat, double userLon);
  QiblaInfo getQiblaInfo(LocationModel userLocation);
  double angleDifference(double angle1, double angle2);
}

