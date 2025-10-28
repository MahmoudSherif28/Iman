import 'package:flutter/material.dart';
import 'package:iman/Features/qibla/data/models/location_model.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_compass.dart';

import 'qiblah_info_card.dart';


class QiblahCompassView extends StatelessWidget {
  final QiblaInfo qiblaInfo;
  final double compassHeading;
  final bool isAligned;

  const QiblahCompassView({
    super.key,
    required this.qiblaInfo,
    required this.compassHeading,
    required this.isAligned,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          QiblaCompass(
            compassHeading: compassHeading,
            qiblaBearing: qiblaInfo.qiblaBearing,
            size: 300,
          ),
          const SizedBox(height: 32),
          if (isAligned) _buildAlignmentIndicator(),
          const SizedBox(height: 24),
          QiblahInfoCard(
            label: 'زاوية البوصلة',
            value: '${compassHeading.toStringAsFixed(1)}°',
            icon: Icons.explore,
            color: Colors.blue,
          ),
          QiblahInfoCard(
            label: 'اتجاه القبلة',
            value: '${qiblaInfo.qiblaBearing.toStringAsFixed(1)}°',
            icon: Icons.mosque,
            color: Colors.green,
          ),
          QiblahInfoCard(
            label: 'المسافة إلى الكعبة',
            value: '${qiblaInfo.distanceToKaaba.toStringAsFixed(0)} كم',
            icon: Icons.straighten,
            color: Colors.orange,
          ),
          _buildLocationInfo(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAlignmentIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Text(
            'أنت متجه نحو القبلة ✓',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'الموقع: ${qiblaInfo.userLocation.latitude.toStringAsFixed(4)}, '
        '${qiblaInfo.userLocation.longitude.toStringAsFixed(4)}',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      ),
    );
  }
}