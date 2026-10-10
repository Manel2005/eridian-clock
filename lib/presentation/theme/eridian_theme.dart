// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';

/// Design tokens and theme definitions for the Eridian Clock application.
///
/// Aesthetic inspired by the Hail Mary and Blip-A spacecraft:
/// - Xenonite Obsidian: Deep dark chassis tones (#0A0D14, #12161F)
/// - Eridian/Astrophage Emerald: Vibrant green glow (#10B981, #34D399)
/// - Petrova Line Cyan: Subtle secondary accents (#38BDF8)
/// - Tactile Metal: Brushed steel and bevel highlights
abstract final class EridianTheme {
  // Color Palette
  static const Color background = Color(0xFF090C10);
  static const Color surface = Color(0xFF111620);
  static const Color surfaceElevated = Color(0xFF18202E);
  static const Color border = Color(0xFF243044);
  static const Color borderSubtle = Color(0xFF1E2736);

  // Accents
  static const Color emeraldGlow = Color(0xFF10B981);
  static const Color emeraldLight = Color(0xFF34D399);
  static const Color petrovaCyan = Color(0xFF38BDF8);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Typography Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Box Shadows
  static const List<BoxShadow> glowShadow = [
    BoxShadow(
      color: Color(0x3310B981),
      blurRadius: 16,
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black87,
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];

  /// Builds the high-contrast dark theme for the application.
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: emeraldGlow,
        secondary: petrovaCyan,
        surface: surface,
      ),
      fontFamily: 'monospace',
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        thickness: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
