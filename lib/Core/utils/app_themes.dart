import 'package:flutter/material.dart';
import 'package:iman/Core/theme/dark_theme.dart';
import 'package:iman/Core/theme/light_theme.dart';

abstract class AppThemes {
  static ThemeData get getLightTheme => lightTheme;
  static ThemeData get getDarkTheme => darkTheme;
}