import 'package:flutter/material.dart';

class AppTheme {
  // Ultra-Premium Habesha Obsidian & Aksumite Gold Palette
  static const Color bgDark = Color(0xFF0E0A08);        // Deep Obsidian Roast Canvas
  static const Color surfaceCard = Color(0xFF17110E);   // Smoked Cedar Surface
  static const Color surfaceElevated = Color(0xFF221914);
  static const Color borderSubtle = Color(0xFF2E221A);  // Warm Bronze Hairline Border

  static const Color accentGold = Color(0xFFD97706);    // Aksumite Gold / Amber
  static const Color accentGoldLight = Color(0xFFF59E0B);
  static const Color accentTerracotta = Color(0xFFB45309);
  static const Color highlandGreen = Color(0xFF10B981); // Kaffa Cloud Forest Emerald

  static const Color textPrimary = Color(0xFFF7EFE6);   // Smoked Parchment Cream
  static const Color textSecondary = Color(0xFFC2B1A1);
  static const Color textMuted = Color(0xFF8C7A6B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: accentGold,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: highlandGreen,
        surface: surfaceCard,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold),
        ),
      ),
      dividerColor: borderSubtle,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          height: 1.55,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
        ),
      ),
    );
  }
}
