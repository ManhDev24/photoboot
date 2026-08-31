import 'package:flutter/material.dart';

class AppTheme {
  // Photoism / Life4Cuts Inspired Premium Kiosk Palette
  static const Color darkBackground = Color(0xFF090D16);
  static const Color surfaceColor = Color(0xFF141C2E);
  static const Color surfaceGlass = Color(0xCC1E293B);
  static const Color primaryAccent = Color(0xFF6366F1); // Electric Indigo
  static const Color secondaryAccent = Color(0xFFEC4899); // Neon Pink
  static const Color goldAccent = Color(0xFFF59E0B); // Luxury Gold
  static const Color successColor = Color(0xFF10B981);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  static List<ColorMatrixFilter> get colorFilters => [
        ColorMatrixFilter('original', 'Original', '✨', [
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        ColorMatrixFilter('bw_mono', 'B&W Film', '🎞️', [
          0.33, 0.33, 0.33, 0, 0,
          0.33, 0.33, 0.33, 0, 0,
          0.33, 0.33, 0.33, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        ColorMatrixFilter('vintage', '70s Vintage', '📷', [
          0.9, 0.1, 0.1, 0, 20,
          0.1, 0.8, 0.1, 0, 10,
          0.1, 0.1, 0.6, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        ColorMatrixFilter('cyberpunk', 'Cyber Neon', '⚡', [
          1.2, 0.0, 0.2, 0, 10,
          0.0, 1.1, 0.3, 0, 0,
          0.3, 0.0, 1.3, 0, 20,
          0, 0, 0, 1, 0,
        ]),
        ColorMatrixFilter('warm_retro', 'Warm Sunset', '🌅', [
          1.1, 0.1, 0.0, 0, 15,
          0.1, 1.0, 0.0, 0, 10,
          0.0, 0.1, 0.8, 0, -10,
          0, 0, 0, 1, 0,
        ]),
        ColorMatrixFilter('soft_glow', 'Soft Glow', '🌸', [
          1.05, 0.05, 0.05, 0, 10,
          0.05, 1.05, 0.05, 0, 10,
          0.05, 0.05, 1.05, 0, 10,
          0, 0, 0, 1, 0,
        ]),
      ];

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        secondary: secondaryAccent,
        surface: surfaceColor,
        error: Colors.redAccent,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class ColorMatrixFilter {
  final String id;
  final String name;
  final String icon;
  final List<double> matrix;

  const ColorMatrixFilter(this.id, this.name, this.icon, this.matrix);
}
