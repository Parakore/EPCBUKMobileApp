import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Forest-inspired Palette
  static const Color primaryGreen = Color(0xFF1B5E20); // Deep Green
  static const Color forestGreen = Color(0xFF2E7D32); // Main Green
  static const Color lightGreen = Color(0xFFA5D6A7); // Accent Green
  static const Color earthBrown = Color(0xFF6D4C41); // Earth Brown
  static const Color softYellow = Color(0xFFFBC02D); // Sun/Flower Yellow
  static const Color naturalBg = Color(0xFFF1F8E9); // Soft Natural White/Green

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: earthBrown,
        tertiary: softYellow,
        background: naturalBg,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: naturalBg,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forestGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
