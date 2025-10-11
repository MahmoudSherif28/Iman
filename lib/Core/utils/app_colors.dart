import 'package:flutter/widgets.dart';

abstract class AppColors {
  // الأساسيات من الصورة
  static const Color primary = Color(0xFF06B576); // اللون الأساسي
  static const Color primaryVariant = Color(0xFF05905E);
  static const Color secondary = Color(0xFFEFF3F2); // اللون الثانوي (فاتح)
  static const Color secondaryVariant = Color(0xFFDDEBE9);

  // حالات عامة
  static const Color success = Color(0xFF06B576);
  static const Color error = Color(0xFFF44336);
  static const Color background = Color(0xFFFFFFFF); // خلفية
  static const Color surface = Color(0xFFF7F8F7);

  // ألوان النصوص على الأسطح
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF06B576);
  static const Color onBackground = Color(0xFF2F2F2F);
  static const Color onSurface = Color(0xFF2F2F2F);
  static const Color onError = Color(0xFFFFFFFF);

  // نصوص وأيقونات (ثيم فاتح)
  static const Color contentPrimary = Color(
    0xFF2F2F2F,
  ); // لون النصوص الرئيسي من الصورة
  static const Color contentSecondary = Color(0xFF414141);
  static const Color contentTertiary = Color(0xFF5A5A5A);
  static const Color contentDisabled = Color(0xFFB8B8B8);

  // نسخ لأنسب للثيم الداكن
  static const Color darkPrimary = Color(0xFF7FD6A9);
  static const Color darkPrimaryVariant = Color(0xFF66C79A);
  static const Color darkSecondary = Color(0xFFBFD9D5);
  static const Color darkSecondaryVariant = Color(0xFFA6CFC9);
  static const Color darkSuccess = Color(0xFF55E36A);
  static const Color darkError = Color(0xFFEF9A9A);

  static const Color darkBackground = Color(0xFF12151E);
  static const Color darkSurface = Color(0xFF1B1F27);

  // ألوان للرسم فوق عناصر الثيم الداكن
  static const Color darkOnPrimary = Color(0xFF12151E);
  static const Color darkOnSecondary = Color(0xFF12151E);
  static const Color darkOnBackground = Color(0xFFF2F2F2);
  static const Color darkOnSurface = Color(0xFFF2F2F2);
  static const Color darkOnError = Color(0xFF12151E);

  // نصوص وأيقونات (ثيم داكن)
  static const Color contentPrimaryDark = Color(0xFFF2F2F2);
  static const Color contentSecondaryDark = Color(0xFFCCCCCC);
  static const Color contentTertiaryDark = Color(0xFF9E9E9E);
  static const Color contentDisabledDark = Color(0xFF6E6E6E);
}
