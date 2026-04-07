import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Forest-inspired Palette (Web-Aligned)
  static const Color greenDark = Color(0xFF0D3B1E);
  static const Color greenMain = Color(0xFF156030);
  static const Color greenMid = Color(0xFF1E7A40);
  static const Color greenLight = Color(0xFF27A84E);
  static const Color greenPale = Color(0xFFE8F5E9);

  static const Color saffron = Color(0xFFF57C00);
  static const Color gold = Color(0xFFC9A227);
  static const Color goldLight = Color(0xFFF4D03F);

  static const Color redAlert = Color(0xFFC62828);
  static const Color purpleAI = Color(0xFF7B1FA2);
  static const Color blueGov = Color(0xFF1565C0);

  static const Color textDark = Color(0xFF1B1B1B);
  static const Color textMid = Color(0xFF4A4A4A);
  static const Color textLight = Color(0xFF8E8E8E);


  // Legacy/App Specific
  static const Color primaryGreen = greenMain;
  static const Color forestGreen = greenMid;
  static const Color lightGreenColors = Color(0xFFA5D6A7);
  static const Color earthBrown = Color(0xFF6D4C41);
  static const Color softYellow = Color(0xFFFBC02D);
  static const Color naturalBg = Color(0xFFF0F4F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: greenMain,
        primary: greenMain,
        secondary: earthBrown,
        tertiary: saffron,
        surface: naturalBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: naturalBg,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: greenDark,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: goldLight,
        ),
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
          backgroundColor: greenMain,
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
          borderSide: const BorderSide(color: greenMain, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: greenMain,
        brightness: Brightness.dark,
        primary: greenMain,
        secondary: gold,
        surface: greenDark,
      ),
      scaffoldBackgroundColor: const Color(0xFF05170C), // Deepest Forest
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: goldLight,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
