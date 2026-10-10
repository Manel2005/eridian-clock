// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/eridian_time.dart';
import '../theme/eridian_theme.dart';
import 'rotor_cylinder.dart';

/// The primary 5-rotor mechanical clock housing display.
class ClockDisplay extends StatelessWidget {
  final EridianTime eridianTime;
  final bool isRealtime;
  final VoidCallback onStepTick;
  final VoidCallback onToggleRealtime;
  final double currentSpeed;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback? onEnterFocusMode;

  const ClockDisplay({
    super.key,
    required this.eridianTime,
    required this.isRealtime,
    required this.onStepTick,
    required this.onToggleRealtime,
    required this.currentSpeed,
    required this.onSpeedChanged,
    this.onEnterFocusMode,
  });

  @override
  Widget build(BuildContext context) {
    final digits = eridianTime.toDigits();
    final rotorLabels = ['6⁴', '6³', '6²', '6¹', '6⁰'];
    final rotorDurations = ['~51m', '~8.5m', '~85s', '~14s', '~2.4s'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sol & Book Lore Header Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: EridianTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: EridianTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: EridianTheme.emeraldGlow,
                            boxShadow: EridianTheme.glowShadow,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ERIDIAN SOL #${eridianTime.sol + 1}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: EridianTheme.emeraldLight,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: EridianTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: EridianTheme.borderSubtle),
                    ),
                    child: const Text(
                      '1 E-sec = 2.366s',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: EridianTheme.textMuted,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // The 5 Mechanical Cylinders Housing
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: EridianTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: EridianTheme.border, width: 2),
                  boxShadow: EridianTheme.cardShadow,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(EridianConstants.rotorCount,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: RotorCylinder(
                          digit: digits[index],
                          label: rotorLabels[index],
                          durationSubtitle: rotorDurations[index],
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sol Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sol Rotation Cycle',
                        style: TextStyle(
                          fontSize: 11,
                          color: EridianTheme.textMuted,
                        ),
                      ),
                      Text(
                        '${(eridianTime.dayProgress * 100).toStringAsFixed(1)}% complete',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: EridianTheme.petrovaCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: eridianTime.dayProgress,
                      minHeight: 6,
                      backgroundColor: EridianTheme.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        EridianTheme.emeraldGlow,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Readouts Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EridianTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: EridianTheme.borderSubtle),
                ),
                child: Column(
                  children: [
                    _buildReadoutRow(
                      label: 'Base-6 Senary:',
                      value: '${eridianTime.toBase6String()}₆',
                      valueColor: EridianTheme.emeraldLight,
                    ),
                    const Divider(height: 18),
                    _buildReadoutRow(
                      label: 'Eridian Glyphs:',
                      value: eridianTime.toGlyphString(),
                      valueColor: EridianTheme.emeraldLight,
                    ),
                    const Divider(height: 18),
                    _buildReadoutRow(
                      label: 'Day Ticks:',
                      value:
                          '${eridianTime.ticks} / ${EridianConstants.ticksPerDay}',
                      valueColor: EridianTheme.textPrimary,
                    ),
                    const Divider(height: 18),
                    _buildReadoutRow(
                      label: 'Earth Duration in Day:',
                      value: _formatEarthDuration(eridianTime.toEarthDuration()),
                      valueColor: EridianTheme.textSecondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Simulation & Playback Controls
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: onStepTick,
                    icon: const Icon(Icons.arrow_forward_ios, size: 14),
                    label: const Text('+1 Tick'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: EridianTheme.textPrimary,
                      side: const BorderSide(color: EridianTheme.border),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: onToggleRealtime,
                    icon: Icon(
                      isRealtime ? Icons.pause : Icons.play_arrow,
                      size: 18,
                    ),
                    label: Text(isRealtime ? 'Synced (Earth)' : 'Resume Realtime'),
                    style: FilledButton.styleFrom(
                      backgroundColor: isRealtime
                          ? EridianTheme.surfaceElevated
                          : EridianTheme.emeraldGlow,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  PopupMenuButton<double>(
                    initialValue: currentSpeed,
                    onSelected: onSpeedChanged,
                    color: EridianTheme.surfaceElevated,
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 1.0, child: Text('Speed: 1x (Realtime)')),
                      const PopupMenuItem(value: 6.0, child: Text('Speed: 6x (Rotor 1)')),
                      const PopupMenuItem(value: 36.0, child: Text('Speed: 36x (Rotor 2)')),
                      const PopupMenuItem(value: 216.0, child: Text('Speed: 216x (Grace Rotor 3)')),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: EridianTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: EridianTheme.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.speed, size: 16, color: EridianTheme.petrovaCyan),
                          const SizedBox(width: 6),
                          Text(
                            '${currentSpeed.toInt()}x Speed',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: EridianTheme.petrovaCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (onEnterFocusMode != null)
                    OutlinedButton.icon(
                      onPressed: onEnterFocusMode,
                      icon: const Icon(Icons.fullscreen, size: 16),
                      label: const Text('Focus Mode'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: EridianTheme.petrovaCyan,
                        side: const BorderSide(color: EridianTheme.border),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadoutRow({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: EridianTheme.textMuted,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  String _formatEarthDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
