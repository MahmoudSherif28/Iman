import 'package:flutter/material.dart';
import 'dart:math' as math;

class QiblaCompass extends StatefulWidget {
  /// زاوية البوصلة الحالية (اتجاه الجهاز من الشمال)
  final double compassHeading;

  /// زاوية القبلة من الشمال الحقيقي
  final double qiblaBearing;

  /// حجم البوصلة
  final double size;

  const QiblaCompass({
    Key? key,
    required this.compassHeading,
    required this.qiblaBearing,
    this.size = 280.0,
  }) : super(key: key);

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousHeading = 0.0;

  @override
  void initState() {
    super.initState();
    _previousHeading = widget.compassHeading;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: _previousHeading,
      end: widget.compassHeading,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.compassHeading != widget.compassHeading) {
      _previousHeading = oldWidget.compassHeading;

      _animation = Tween<double>(
        begin: _previousHeading,
        end: widget.compassHeading,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // حساب الزاوية النسبية للقبلة بالنسبة لاتجاه الجهاز
        final double relativeQiblaAngle =
            widget.qiblaBearing - _animation.value;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // خلفية البوصلة
              _buildCompassBackground(),

              // دائرة البوصلة الدوارة مع الاتجاهات
              Transform.rotate(
                angle: _degreesToRadians(-_animation.value),
                child: _buildCompassRose(),
              ),

              // سهم القبلة (يدور بالنسبة لاتجاه الجهاز)
              Transform.rotate(
                angle: _degreesToRadians(relativeQiblaAngle),
                child: _buildQiblaArrow(),
              ),

              // مؤشر الشمال الثابت في الأعلى
              _buildNorthIndicator(),

              // دائرة مركزية
              _buildCenterCircle(),
            ],
          ),
        );
      },
    );
  }

  /// بناء خلفية البوصلة
  Widget _buildCompassBackground() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.white, Colors.grey.shade100]),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
    );
  }

  /// بناء وردة البوصلة مع الاتجاهات والعلامات
  Widget _buildCompassRose() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(painter: _CompassRosePainter()),
    );
  }

  /// بناء سهم القبلة
  Widget _buildQiblaArrow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // السهم المثلثي
        CustomPaint(
          size: Size(40, widget.size * 0.35),
          painter: _QiblaArrowPainter(),
        ),
        SizedBox(height: widget.size * 0.3),
      ],
    );
  }

  /// بناء مؤشر الشمال الثابت
  Widget _buildNorthIndicator() {
    return Positioned(
      top: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          'ش',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// بناء الدائرة المركزية
  Widget _buildCenterCircle() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.green.shade700, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: Center(
        child: Icon(Icons.my_location, color: Colors.green.shade700, size: 30),
      ),
    );
  }

  /// تحويل من درجات إلى راديان
  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }
}

/// رسام وردة البوصلة
class _CompassRosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // رسم العلامات الدرجية (كل 10 درجات)
    for (int i = 0; i < 36; i++) {
      final double angle = i * 10.0;
      _drawTick(canvas, center, radius, angle, i % 3 == 0);
    }

    // رسم الاتجاهات الرئيسية
    _drawDirection(canvas, center, radius, 0, 'ش', Colors.red); // شمال
    _drawDirection(canvas, center, radius, 90, 'رق', Colors.blue); // شرق
    _drawDirection(canvas, center, radius, 180, 'ج', Colors.grey); // جنوب
    _drawDirection(canvas, center, radius, 270, 'غ', Colors.blue); // غرب
  }

  /// رسم علامة درجة
  void _drawTick(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    bool isLarge,
  ) {
    final double radian = angle * math.pi / 180;
    final double tickLength = isLarge ? 15.0 : 8.0;
    final double tickWidth = isLarge ? 2.0 : 1.0;

    final Paint paint = Paint()
      ..color = isLarge ? Colors.black87 : Colors.black38
      ..strokeWidth = tickWidth
      ..strokeCap = StrokeCap.round;

    final double startRadius = radius - 25;
    final double endRadius = startRadius - tickLength;

    final Offset start = Offset(
      center.dx + startRadius * math.sin(radian),
      center.dy - startRadius * math.cos(radian),
    );

    final Offset end = Offset(
      center.dx + endRadius * math.sin(radian),
      center.dy - endRadius * math.cos(radian),
    );

    canvas.drawLine(start, end, paint);
  }

  /// رسم حرف الاتجاه
  void _drawDirection(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    String label,
    Color color,
  ) {
    final double radian = angle * math.pi / 180;
    final double textRadius = radius - 50;

    final Offset position = Offset(
      center.dx + textRadius * math.sin(radian),
      center.dy - textRadius * math.cos(radian),
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسام سهم القبلة
class _QiblaArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green.shade700
      ..style = PaintingStyle.fill;

    final Paint outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path();

    // رسم السهم المثلثي
    path.moveTo(size.width / 2, 0); // قمة السهم
    path.lineTo(0, size.height); // زاوية يسار
    path.lineTo(size.width, size.height); // زاوية يمين
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
