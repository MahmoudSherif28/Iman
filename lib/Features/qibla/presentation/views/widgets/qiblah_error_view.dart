import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Core/errors/location_exception.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Features/qibla/data/repos/location_repos/location_repo.dart';
import 'package:iman/Features/qibla/presentation/manager/qiblah/qiblah_cubit.dart';


class QiblahErrorView extends StatelessWidget {
  final QiblahError state;

  const QiblahErrorView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
            const SizedBox(height: 24),
            Text(
              'تعذر تحديد موقعك',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_errorRequiresSettings(state.errorType))
          ElevatedButton.icon(
            onPressed: () => _openSettings(context, state.errorType),
            icon: const Icon(Icons.settings),
            label: const Text('فتح الإعدادات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => context.read<QiblahCubit>().getQiblaDirection(),
          icon: const Icon(Icons.refresh),
          label: const Text('إعادة المحاولة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  bool _errorRequiresSettings(LocationErrorType errorType) {
    return errorType == LocationErrorType.serviceDisabled;
  }

  void _openSettings(BuildContext context, LocationErrorType errorType) {
    final locationRepository = getIt<LocationRepository>();
    if (errorType == LocationErrorType.serviceDisabled) {
      locationRepository.openLocationSettings();
    } else {
      locationRepository.openAppSettings();
    }
  }
}