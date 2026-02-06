import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Core/errors/location_exception.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Features/qibla/data/repos/location_repos/location_repo.dart';
import 'package:iman/Features/qibla/presentation/manager/qiblah/qiblah_cubit.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_appbar.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_compass_view.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_error_view.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_initial_view.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_loading_view.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_no_compass_view.dart';

class QiblahViewBody extends StatefulWidget {
  const QiblahViewBody({super.key});

  @override
  State<QiblahViewBody> createState() => _QiblahViewBodyState();
}

class _QiblahViewBodyState extends State<QiblahViewBody>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final qiblaCubit = context.read<QiblahCubit>();

    if (state == AppLifecycleState.paused) {
      // إيقاف البوصلة عند الخروج من التطبيق
    } else if (state == AppLifecycleState.resumed) {
      // إعادة تشغيل البوصلة عند العودة للتطبيق
      qiblaCubit.restartCompassListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QiblahCubit, QiblahState>(
      listener: (context, state) {
        if (state is QiblahError) {
          _showSettingsDialog(context, state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: QiblahAppBar(state: state),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(QiblahState state) {
    if (state is QiblahInitial) {
      return const QiblahInitialView();
    } else if (state is QiblahLoading) {
      return const QiblahLoadingView();
    } else if (state is QiblahLoaded) {
      return QiblahCompassView(
        qiblaInfo: state.qiblaInfo,
        compassHeading: 0.0,
        isAligned: false,
      );
    } else if (state is QiblaCompassListening) {
      return QiblahCompassView(
        qiblaInfo: state.qiblaInfo,
        compassHeading: state.compassHeading,
        isAligned: state.isAligned,
      );
    } else if (state is QiblaNoCompass) {
      return QiblahNoCompassView(qiblaInfo: state.qiblaInfo);
    } else if (state is QiblahError) {
      return QiblahErrorView(state: state);
    } else {
      return const SizedBox();
    }
  }

  void _showSettingsDialog(BuildContext context, QiblahError state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإعدادات المطلوبة'),
        content: Text(state.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openSettings(context, state.errorType);
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
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
