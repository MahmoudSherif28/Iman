import 'package:flutter/material.dart';
import 'package:iman/Core/utils/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: 'IBM Plex Sans Arabic',
  scaffoldBackgroundColor: AppColors.darkBackground,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkOnSecondary,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    primaryContainer: AppColors.darkPrimaryVariant,
    secondaryContainer: AppColors.darkSecondaryVariant,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkPrimary,
    foregroundColor: AppColors.darkOnPrimary,
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
    backgroundColor: AppColors.darkPrimary,
    foregroundColor: AppColors.darkOnPrimary,
  ),
  iconTheme: const IconThemeData(color: AppColors.contentPrimaryDark),
  primaryIconTheme: const IconThemeData(color: AppColors.darkOnPrimary),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.contentPrimaryDark),
    bodyMedium: TextStyle(color: AppColors.contentSecondaryDark),
    bodySmall: TextStyle(color: AppColors.contentTertiaryDark),
    titleLarge: TextStyle(color: AppColors.contentPrimaryDark),
  ),
  disabledColor: AppColors.contentDisabledDark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkOnPrimary,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.contentPrimaryDark,
      side: const BorderSide(color: AppColors.darkPrimaryVariant),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    hintStyle: TextStyle(color: AppColors.contentTertiaryDark),
  ),
);