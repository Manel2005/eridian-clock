// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';

import '../theme/eridian_theme.dart';
import 'eridian_glyph.dart';

/// A 3D-styled mechanical cylinder drum representing one rotor on Rocky's clock.
class RotorCylinder extends StatelessWidget {
  /// The current digit displayed on this rotor (0 through 5).
  final int digit;

  /// Power of 6 label (e.g. "6⁴", "6³", etc.).
  final String label;

  /// Approximate Earth duration of one step (e.g. "~2.4s", "~51m").
  final String durationSubtitle;

  /// Width of the cylinder drum.
  final double width;

  /// Height of the cylinder drum.
  final double height;

  const RotorCylinder({
    super.key,
    required this.digit,
    required this.label,
    required this.durationSubtitle,
    this.width = 66.0,
    this.height = 104.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mechanical Rotor Housing
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF0F141D),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: EridianTheme.border, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cylindrical lighting: curved highlight at center, dark shadows on top & bottom
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xE0000000), // Top deep shadow
                        Color(0x30000000),
                        Color(0x18FFFFFF), // Center reflective sheen
                        Color(0x30000000),
                        Color(0xE0000000), // Bottom deep shadow
                      ],
                      stops: [0.0, 0.22, 0.5, 0.78, 1.0],
                    ),
                  ),
                ),
              ),

              // Horizontal Mechanical Groove Lines (textured drum)
              Positioned(
                top: height * 0.18,
                left: 4,
                right: 4,
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              Positioned(
                bottom: height * 0.18,
                left: 4,
                right: 4,
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),

              // Animated Rolling Digit Content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final inAnimation =
                      Tween<Offset>(
                        begin: const Offset(0.0, -0.65),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        ),
                      );
                  return SlideTransition(
                    position: inAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Column(
                  key: ValueKey<int>(digit),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Vector Eridian Glyph with Glow
                    EridianGlyph(
                      digit: digit,
                      size: width * 0.58,
                      color: EridianTheme.emeraldLight,
                      strokeWidth: 3.6,
                      glow: true,
                    ),
                    const SizedBox(height: 5),
                    // Reference human numeral
                    Text(
                      digit.toString(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: EridianTheme.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Rotor Positional Label
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: EridianTheme.textSecondary,
          ),
        ),
        Text(
          durationSubtitle,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            color: EridianTheme.textMuted,
          ),
        ),
      ],
    );
  }
}
