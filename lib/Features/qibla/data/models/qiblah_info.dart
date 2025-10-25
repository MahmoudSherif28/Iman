import 'package:iman/Features/qibla/data/models/location_model.dart';

class QiblaInfo {
  final double qiblaBearing;
  final double distanceToKaaba;
  final LocationModel userLocation;

  QiblaInfo({
    required this.qiblaBearing,
    required this.distanceToKaaba,
    required this.userLocation,
  });

  @override
  String toString() {
    return 'QiblaInfo(bearing: ${qiblaBearing.toStringAsFixed(1)}°, '
        'distance: ${distanceToKaaba.toStringAsFixed(0)} km)';
  }
}
