// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';

import '../theme/eridian_theme.dart';
import 'eridian_glyph.dart';

/// In-app documentation and lore reference from Andy Weir's novel.
class LoreDialog extends StatelessWidget {
  const LoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: EridianTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: EridianTheme.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SCIENCE & NOVEL LORE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: EridianTheme.emeraldLight,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    color: EridianTheme.textMuted,
                  ),
                ],
              ),
              const Divider(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildSectionHeader('1. Biology & Base-6 (Senary) System'),
                    const Text(
                      'Rocky and the Eridians possess five limbs around a central carapace. '
                      'However, their manipulation organs consist of two hands with three fingers each, '
                      'giving them six fingers total. As humans naturally developed base-10 from 10 fingers, '
                      'Eridians naturally count in base-6 (digits 0 through 5).',
                      style: TextStyle(
                        color: EridianTheme.textSecondary,
                        height: 1.45,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildSectionHeader('2. The Stroke-Count Numerals'),
                    const Text(
                      'Because Eridians perceive their world through echolocation and tactile sensation, '
                      'their numeral glyphs are defined by the count of straight line segments:',
                      style: TextStyle(
                        color: EridianTheme.textSecondary,
                        height: 1.45,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: EridianTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: EridianTheme.borderSubtle),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(6, (digit) {
                          return Column(
                            children: [
                              EridianGlyph(
                                digit: digit,
                                size: 28,
                                strokeWidth: 2.8,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$digit',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: EridianTheme.textMuted,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildSectionHeader('3. Chapter 10 Time Measurement'),
                    const Text(
                      'To establish a shared baseline of time, Ryland Grace times the rotation of '
                      'the 3rd rotor on Rocky\'s mechanical clock with his digital stopwatch.\n\n'
                      '• 3rd Rotor Lap: 6³ = 216 Eridian ticks.\n'
                      '• Stopwatch Measurement: 511.0 Earth seconds.\n'
                      '• 1 Eridian Tick = 511.0 / 216 ≈ 2.36574 Earth seconds.\n'
                      '• Full Eridian Day (Sol) = 6⁵ = 7,776 ticks ≈ 18,396s (~5.11 hours).',
                      style: TextStyle(
                        color: EridianTheme.textSecondary,
                        height: 1.45,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: EridianTheme.petrovaCyan,
        ),
      ),
    );
  }
}
