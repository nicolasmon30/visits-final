import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color darkBrown = Color(0xFF0d1b2a);
  static const Color darkBlue = Color(0xFF1b263b);
  static const Color mediumBlue = Color(0xFF415a77);
  static const Color lightBlue = Color(0xFF778da9);
  static const Color paleBlue = Color(0xFFe0e1dd);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.montserrat().fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.mediumBlue,
        onPrimary: Colors.white,
        primaryContainer: AppColors.lightBlue,
        onPrimaryContainer: AppColors.darkBlue,
        secondary: AppColors.lightBlue,
        onSecondary: AppColors.darkBlue,
        secondaryContainer: AppColors.paleBlue,
        onSecondaryContainer: AppColors.darkBrown,
        surface: Colors.white,
        onSurface: AppColors.darkBrown,
        surfaceVariant: AppColors.paleBlue,
        onSurfaceVariant: AppColors.darkBlue,
        outline: AppColors.mediumBlue,
        background: AppColors.paleBlue,
        onBackground: AppColors.darkBrown,
        error: Colors.red,
        onError: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.montserrat().fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lightBlue,
        onPrimary: AppColors.darkBrown,
        primaryContainer: AppColors.mediumBlue,
        onPrimaryContainer: AppColors.paleBlue,
        secondary: AppColors.paleBlue,
        onSecondary: AppColors.darkBlue,
        secondaryContainer: AppColors.darkBlue,
        onSecondaryContainer: AppColors.paleBlue,
        surface: AppColors.darkBrown,
        onSurface: AppColors.paleBlue,
        surfaceVariant: AppColors.darkBlue,
        onSurfaceVariant: AppColors.lightBlue,
        outline: AppColors.mediumBlue,
        background: AppColors.darkBrown,
        onBackground: AppColors.paleBlue,
        error: Colors.redAccent,
        onError: AppColors.darkBrown,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
