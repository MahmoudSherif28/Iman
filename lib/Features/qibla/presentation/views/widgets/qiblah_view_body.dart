



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Core/errors/location_excaption.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Features/qibla/data/models/location_model.dart';
import 'package:iman/Features/qibla/data/repos/location%20repos/location_repo.dart';
import 'package:iman/Features/qibla/presentation/manager/qiblah/qiblah_cubit.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_compass.dart';

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
      // (سيتم إيقافها تلقائياً في close method)
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
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, QiblahState state) {
    return AppBar(
      title: const Text(
        'اتجاه القبلة',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.green.shade700,
      elevation: 0,
      actions: [
        if (state is! QiblahInitial && state is! QiblahLoading)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<QiblahCubit>().getQiblaDirection(),
            tooltip: 'تحديث الموقع',
          ),
        if (state is QiblaNoCompass)
          IconButton(
            icon: const Icon(Icons.compass_calibration),
            onPressed: () =>
                context.read<QiblahCubit>().restartCompassListening(),
            tooltip: 'إعادة تشغيل البوصلة',
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, QiblahState state) {
    if (state is QiblahInitial) {
      return _buildInitialView(context);
    } else if (state is QiblahLoading) {
      return _buildLoadingView();
    } else if (state is QiblahLoaded) {
      return _buildQiblaView(context, state.qiblaInfo, 0.0, false);
    } else if (state is QiblaCompassListening) {
      return _buildQiblaView(
        context,
        state.qiblaInfo,
        state.compassHeading,
        state.isAligned,
      );
    } else if (state is QiblaNoCompass) {
      return _buildNoCompassView(context, state.qiblaInfo);
    } else if (state is QiblahError) {
      return _buildErrorView(context, state);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compass_calibration,
            size: 80,
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 24),
          const Text(
            'اكتشف اتجاه القبلة',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'اضغط على الزر لمعرفة اتجاه القبلة من موقعك الحالي',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.read<QiblahCubit>().getQiblaDirection(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'اكتشف اتجاه القبلة',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
          ),
          const SizedBox(height: 24),
          Text(
            'جارٍ تحديد موقعك...',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          Text(
            'تأكد من تفعيل GPS',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildQiblaView(
    BuildContext context,
    QiblaInfo qiblaInfo,
    double? compassHeading,
    bool isAligned,
  ) {
    final effectiveCompassHeading = compassHeading ?? 0.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          // البوصلة
          const SizedBox(height: 40),
          QiblaCompass(
            compassHeading: effectiveCompassHeading,
            qiblaBearing: qiblaInfo.qiblaBearing,
            size: 300,
          ),

          const SizedBox(height: 32),

          // مؤشر المحاذاة
          if (isAligned)
            Container(
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
            ),

          const SizedBox(height: 24),

          // معلومات الزوايا
          _buildInfoCard(
            'زاوية البوصلة',
            '${effectiveCompassHeading.toStringAsFixed(1)}°',
            Icons.explore,
            Colors.blue,
          ),

          _buildInfoCard(
            'اتجاه القبلة',
            '${qiblaInfo.qiblaBearing.toStringAsFixed(1)}°',
            Icons.mosque,
            Colors.green,
          ),

          _buildInfoCard(
            'المسافة إلى الكعبة',
            '${qiblaInfo.distanceToKaaba.toStringAsFixed(0)} كم',
            Icons.straighten,
            Colors.orange,
          ),

          // معلومات الموقع
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'الموقع: ${qiblaInfo.userLocation.latitude.toStringAsFixed(4)}, '
              '${qiblaInfo.userLocation.longitude.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNoCompassView(BuildContext context, QiblaInfo qiblaInfo) {
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
            Container(
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
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<QiblahCubit>().restartCompassListening(),
                  child: const Text('إعادة تشغيل البوصلة'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      context.read<QiblahCubit>().getQiblaDirection(),
                  child: const Text('تحديث الموقع'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, QiblahError state) {
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
            Row(
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
                  onPressed: () =>
                      context.read<QiblahCubit>().getQiblaDirection(),
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
            ),
          ],
        ),
      ),
    );
  }

  /// بناء بطاقة معلومات
  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
