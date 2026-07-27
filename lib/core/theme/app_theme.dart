import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF00A6DE); // ciano ActionLabs
  static const Color resultBackground = Color(0xFFE7F6FD); // caixa da taxa
  static const Color positive = Color(0xFF2FA84F); // close diff positivo
  static const Color negative = Color(0xFFE5484D); // close diff negativo
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}
