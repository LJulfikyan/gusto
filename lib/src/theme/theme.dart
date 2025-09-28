import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _primarySeedColor = Color(0xFFE74C3C); // A modern, appetizing red

class AppTheme {
  static final TextTheme _appTextTheme = TextTheme(
    displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.oswald(fontSize: 45, fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.oswald(fontSize: 36, fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.w700),
    headlineSmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w700),
    titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.openSans(fontSize: 16),
    bodyMedium: GoogleFonts.openSans(fontSize: 14),
    bodySmall: GoogleFonts.openSans(fontSize: 12),
    labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w700),
    labelMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w700),
    labelSmall: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w700),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primarySeedColor,
        brightness: Brightness.light,
        primary: _primarySeedColor,
        secondary: const Color(0xFFF1C40F), // A contrasting yellow
        surface: const Color(0xFFF7F7F7),
        onSurface: Colors.black87,
        error: Colors.red.shade700,
      ),
      textTheme: _appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: _appTextTheme.headlineSmall?.copyWith(color: Colors.black87),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primarySeedColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: _appTextTheme.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primarySeedColor, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primarySeedColor,
        brightness: Brightness.dark,
        primary: _primarySeedColor,
        secondary: const Color(0xFFF1C40F),
        surface: const Color(0xFF121212),
        onSurface: Colors.white,
        error: Colors.red.shade400,
      ),
      textTheme: _appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: _appTextTheme.headlineSmall?.copyWith(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primarySeedColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: _appTextTheme.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: const Color(0xFF1E1E1E),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primarySeedColor, width: 2),
        ),
      ),
    );
  }
}
