import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/qibla_viewmodel.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QiblaViewModel()..initQibla(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            'اتجاه القبلة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFF00897B),
          foregroundColor: Colors.white,
        ),
        body: Consumer<QiblaViewModel>(
          builder: (context, viewModel, _) {
            // حالة التحميل
            if (viewModel.isLoading) {
              return _buildLoadingState();
            }

            // حالة الخطأ
            if (viewModel.errorMessage != null) {
              return _buildErrorState(context, viewModel);
            }

            // حالة عدم وجود بيانات
            if (viewModel.qiblaData == null) {
              return _buildNoDataState(viewModel);
            }

            // حالة النجاح - عرض البوصلة
            return _buildQiblaCompass(context, viewModel);
          },
        ),
      ),
    );
  }

  // حالة التحميل
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF00897B),
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'جارٍ تحديد موقعك...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قد يستغرق هذا بضع ثوانٍ',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // حالة الخطأ
  Widget _buildErrorState(BuildContext context, QiblaViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا يمكن تحديد اتجاه القبلة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              viewModel.errorMessage!,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => viewModel.retry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // حالة عدم وجود بيانات
  Widget _buildNoDataState(QiblaViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد بيانات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => viewModel.retry(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  // عرض البوصلة
  Widget _buildQiblaCompass(BuildContext context, QiblaViewModel viewModel) {
    final angle = viewModel.qiblaAngle ?? 0;
    final isPointingToQibla = viewModel.isPointingToQibla;
    final isNearQibla = viewModel.isNearQibla;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height:20),
          // مؤشر الدقة
          _buildAccuracyIndicator(isPointingToQibla, isNearQibla),

          const SizedBox(height: 30),

          // البوصلة الرئيسية
          _buildMainCompass(angle),

          const SizedBox(height: 30),

          // معلومات الزاوية
          _buildAngleInfo(angle, isPointingToQibla),

          const SizedBox(height: 20),

          // معلومات الموقع
          _buildLocationInfo(viewModel),

          const SizedBox(height: 20),

          // التعليمات
          _buildInstructions(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // مؤشر الدقة
  Widget _buildAccuracyIndicator(bool isPointingToQibla, bool isNearQibla) {
    Color color;
    String text;
    IconData icon;

    if (isPointingToQibla) {
      color = Colors.green;
      text = 'اتجاه صحيح ✓';
      icon = Icons.check_circle;
    } else if (isNearQibla) {
      color = Colors.orange;
      text = 'قريب من الاتجاه';
      icon = Icons.track_changes;
    } else {
      color = Colors.grey;
      text = 'حرك الجهاز للاتجاه الصحيح';
      icon = Icons.explore;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // البوصلة الرئيسية
  Widget _buildMainCompass(double angle) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // دائرة الخلفية
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // صورة البوصلة (الكعبة) - تدور
          AnimatedRotation(
            turns: angle / -360,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal[50],
              ),
              child: Image.asset(
                'assets/images/bosla.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // السهم الثابت في الأعلى
          Positioned(
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF00897B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // معلومات الزاوية
  Widget _buildAngleInfo(double angle, bool isPointingToQibla) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore,
                color: isPointingToQibla
                    ? Colors.green
                    : const Color(0xFF00897B),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'زاوية الانحراف',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${angle.abs().toStringAsFixed(1)}°',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isPointingToQibla ? Colors.green : const Color(0xFF00897B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            angle > 0
                ? 'اتجه يميناً ←'
                : angle < 0
                ? 'اتجه يساراً →'
                : 'اتجاه صحيح ✓',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // معلومات الموقع والمسافة
  Widget _buildLocationInfo(QiblaViewModel viewModel) {
    if (viewModel.qiblaData == null) return const SizedBox.shrink();

    final data = viewModel.qiblaData!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.location_on,
            'موقعك الحالي',
            '${data.latitude.toStringAsFixed(4)}°, ${data.longitude.toStringAsFixed(4)}°',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.straighten,
            'المسافة إلى الكعبة',
            '${data.distanceToKaaba.toStringAsFixed(0)} كم',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.navigation,
            'اتجاه القبلة الحقيقي',
            '${data.qiblaDirection.toStringAsFixed(1)}°',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF00897B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF00897B), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // التعليمات
  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00897B).withOpacity(0.1),
            const Color(0xFF00897B).withOpacity(0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00897B).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF00897B), size: 22),
              SizedBox(width: 10),
              Text(
                'كيفية الاستخدام',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionItem('1', 'أمسك الجهاز بشكل أفقي (مستوٍ)'),
          const SizedBox(height: 10),
          _buildInstructionItem('2', 'ابحث عن السهم الأخضر ووجّه جهازك نحوه'),
          const SizedBox(height: 10),
          _buildInstructionItem(
            '3',
            'عندما تكون الزاوية قريبة من 0° فأنت في الاتجاه الصحيح',
          ),
          const SizedBox(height: 10),
          _buildInstructionItem(
            '4',
            'حرّك الجهاز بحركة ∞ إذا طُلب منك معايرة البوصلة',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF00897B),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
