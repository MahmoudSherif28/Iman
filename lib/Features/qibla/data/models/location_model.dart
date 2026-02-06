

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });

  factory LocationModel.fromPosition(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, accuracy, timestamp];
}

class QiblaInfo extends Equatable {
  final double qiblaBearing;
  final double distanceToKaaba;
  final LocationModel userLocation;

  const QiblaInfo({
    required this.qiblaBearing,
    required this.distanceToKaaba,
    required this.userLocation,
  });

  @override
  String toString() {
    return 'QiblaInfo(bearing: ${qiblaBearing.toStringAsFixed(1)}°, '
        'distance: ${distanceToKaaba.toStringAsFixed(0)} km)';
  }

  @override
  List<Object> get props => [qiblaBearing, distanceToKaaba, userLocation];
}
