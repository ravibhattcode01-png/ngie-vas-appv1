import 'package:flutter/material.dart';

class AppConfig {
  // 🔧 Point this at your deployed backend, e.g. https://telcom.ngie.in/api
  // For local testing on an Android emulator use http://10.0.2.2:8000/api
  static const String apiBaseUrl = 'https://telcom.ngie.in/api';
}

class Brand {
  static const navy = Color(0xFF1B2A4A);
  static const teal = Color(0xFF0E7C7B);
  static const gold = Color(0xFFC9A227);
  static const mist = Color(0xFFF1F5F9);
  static const ink = Color(0xFF0F172A);

  static ThemeData theme() {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: teal),
      scaffoldBackgroundColor: mist,
      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE8EDF3)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: teal, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
