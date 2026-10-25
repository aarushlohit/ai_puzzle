import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primaryBackground = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF7F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color primaryText = Color(0xFF18181B);
  static const Color secondaryText = Color(0xFF71717A);
  static const Color subtleText = Color(0xFFA1A1AA);
  
  // Brand Accents
  static const Color accentPurple = Color(0xFF7559F5);
  static const Color accentPurpleLight = Color(0xFF9078F8);
  static const Color accentLavender = Color(0xFFEDE9FE);
  static const Color accentLavenderLight = Color(0xFFF5F3FF);
  
  // Functional Status Colors
  static const Color success = Color(0xFF22A06B);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFE9A23B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFE35D6A);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Border & Dividers
  static const Color border = Color(0xFFE4E4E7);
  static const Color borderSubtle = Color(0xFFF4F4F5);

  // Dark Mode Overrides
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSecondaryBackground = Color(0xFF1E293B);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkPrimaryText = Color(0xFFF8FAFC);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.secondaryBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentPurple,
        onPrimary: Colors.white,
        secondary: AppColors.accentLavender,
        onSecondary: AppColors.accentPurple,
        surface: AppColors.cardBackground,
        onSurface: AppColors.primaryText,
        error: AppColors.error,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            inherit: true,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentPurple,
          side: const BorderSide(color: AppColors.accentPurple, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            inherit: true,
          ),
        ),
      ),
      fontFamily: 'Roboto',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentPurpleLight,
        onPrimary: Colors.white,
        secondary: AppColors.accentPurple,
        onSecondary: Colors.white,
        surface: AppColors.darkCardBackground,
        onSurface: AppColors.darkPrimaryText,
        error: AppColors.error,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkPrimaryText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkPrimaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          inherit: true,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurpleLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            inherit: true,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentPurpleLight,
          side: const BorderSide(color: AppColors.accentPurpleLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            inherit: true,
          ),
        ),
      ),
      fontFamily: 'Roboto',
    );
  }
}
