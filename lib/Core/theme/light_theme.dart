import 'package:flutter/material.dart';
import 'package:iman/Core/utils/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'IBM Plex Sans Arabic',
  scaffoldBackgroundColor: AppColors.background,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    error: AppColors.error,
    onError: AppColors.onError,
    primaryContainer: AppColors.primaryVariant,
    secondaryContainer: AppColors.secondaryVariant,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 0,
    centerTitle: false,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: ZoomPageTransitionsBuilder(),
      TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    },
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
  ),
  iconTheme: const IconThemeData(color: AppColors.contentPrimary),
  primaryIconTheme: const IconThemeData(color: AppColors.onPrimary),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.contentPrimary),
    bodyMedium: TextStyle(color: AppColors.contentSecondary),
    bodySmall: TextStyle(color: AppColors.contentTertiary),
    titleLarge: TextStyle(color: AppColors.contentPrimary),
  ),
  disabledColor: AppColors.contentDisabled,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primaryVariant),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    hintStyle: TextStyle(color: AppColors.contentTertiary),
  ),
);