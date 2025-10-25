class QiblaModel {
  final double latitude;
  final double longitude;
  final double qiblaDirection;
  final double distanceToKaaba; // المسافة إلى الكعبة بالكيلومتر

  QiblaModel({
    required this.latitude,
    required this.longitude,
    required this.qiblaDirection,
    required this.distanceToKaaba,
  });

  // نسخة محسّنة للطباعة
  @override
  String toString() {
    return 'QiblaModel(lat: $latitude, lng: $longitude, direction: ${qiblaDirection.toStringAsFixed(2)}°, distance: ${distanceToKaaba.toStringAsFixed(2)} km)';
  }
}
