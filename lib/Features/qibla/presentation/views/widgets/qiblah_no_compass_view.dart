import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Features/qibla/data/models/location_model.dart';
import 'package:iman/Features/qibla/presentation/manager/qiblah/qiblah_cubit.dart';

class QiblahNoCompassView extends StatelessWidget {
  final QiblaInfo qiblaInfo;

  const QiblahNoCompassView({super.key, required this.qiblaInfo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compass_calibration,
              size: 80,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'مستشعر البوصلة غير متوفر',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'جهازك لا يدعم مستشعر البوصلة المغناطيسية\n'
              'أو يحتاج إلى معايرة',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildQiblaInfo(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQiblaInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Text(
            'اتجاه القبلة من موقعك:',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            '${qiblaInfo.qiblaBearing.toStringAsFixed(1)}°',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          Text(
            'من الشمال الحقيقي',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () =>
              context.read<QiblahCubit>().restartCompassListening(),
          child: const Text('إعادة تشغيل البوصلة'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => context.read<QiblahCubit>().getQiblaDirection(),
          child: const Text('تحديث الموقع'),
        ),
      ],
    );
  }
}