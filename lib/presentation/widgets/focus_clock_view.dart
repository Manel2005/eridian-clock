// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/eridian_time.dart';
import '../theme/eridian_theme.dart';
import 'rotor_cylinder.dart';

/// Fullscreen ambient focus mode displaying exclusively the mechanical clock.
///
/// Designed as a desk clock / zen mode with enlarged 3D rotating cylinders,
/// deep xenonite space background, astrophage radial glow, and clean aesthetics.
class FocusClockView extends StatelessWidget {
  final EridianTime eridianTime;
  final VoidCallback onExit;

  const FocusClockView({
    super.key,
    required this.eridianTime,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final digits = eridianTime.toDigits();
    final rotorLabels = ['6⁴', '6³', '6²', '6¹', '6⁰'];
    final rotorDurations = ['~51m', '~8.5m', '~85s', '~14s', '~2.4s'];

    return Scaffold(
      backgroundColor: const Color(0xFF06080D), // Deepest obsidian space
      body: Stack(
        children: [
          // Ambient Astrophage Emerald Glow in Background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    EridianTheme.emeraldGlow.withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Centered Mechanical Rotors Assembly
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sol & Glyph Ambient Header
                  Text(
                    'ERIDIAN SOL #${eridianTime.sol + 1}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      letterSpacing: 4.0,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: EridianTheme.emeraldLight.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${eridianTime.toBase6String()}₆   •   ${eridianTime.toGlyphString()}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: EridianTheme.textPrimary,
                      letterSpacing: 2.0,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Enlarged 3D Rotors Housing
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E131C),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: EridianTheme.border, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 36,
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: Color(0x1A10B981),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(EridianConstants.rotorCount, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7.0),
                            child: RotorCylinder(
                              digit: digits[index],
                              label: rotorLabels[index],
                              durationSubtitle: rotorDurations[index],
                              width: 82.0,
                              height: 128.0,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sol Rotation Progress Indicator
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: eridianTime.dayProgress,
                            minHeight: 5,
                            backgroundColor: const Color(0xFF161E2C),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              EridianTheme.emeraldGlow,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${eridianTime.ticks} / ${EridianConstants.ticksPerDay} ticks '
                          '(${(eridianTime.dayProgress * 100).toStringAsFixed(1)}% of Eridian Day)',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: EridianTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Exit Focus Mode Icon Button (Top-Right)
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: IconButton(
                tooltip: 'Exit Focus Mode (Esc)',
                onPressed: onExit,
                icon: const Icon(Icons.fullscreen_exit),
                color: EridianTheme.textMuted,
                hoverColor: EridianTheme.surfaceElevated,
                iconSize: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
