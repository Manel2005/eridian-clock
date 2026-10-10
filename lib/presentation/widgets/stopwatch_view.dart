// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/eridian_stopwatch.dart';
import '../theme/eridian_theme.dart';
import 'rotor_cylinder.dart';

/// Recreates Ryland Grace's Chapter 10 lab experiment.
class StopwatchView extends StatefulWidget {
  const StopwatchView({super.key});

  @override
  State<StopwatchView> createState() => _StopwatchViewState();
}

class _StopwatchViewState extends State<StopwatchView> {
  final EridianStopwatch _stopwatch = EridianStopwatch();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_stopwatch.state == EridianStopwatchState.running) {
        setState(() {
          _stopwatch.update();
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _toggleStartPause() {
    setState(() {
      if (_stopwatch.state == EridianStopwatchState.running) {
        _stopwatch.pause();
      } else {
        _stopwatch.start();
      }
    });
  }

  void _reset() {
    setState(() {
      _stopwatch.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eridianTime = _stopwatch.eridianTime;
    final digits = eridianTime.toDigits();
    final rotorLabels = ['6⁴', '6³', '6²', '6¹', '6⁰'];
    final rotorDurations = ['~51m', '~8.5m', '~85s', '~14s', '~2.4s'];

    final bool isGraceMilestoneHit = eridianTime.ticks >= 216;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Experiment Intro Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EridianTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: EridianTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.science,
                          size: 18,
                          color: EridianTheme.petrovaCyan,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'EXPERIMENT: ROTOR 3 LAP TIMING',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: EridianTheme.petrovaCyan,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Replicate Ryland Grace\'s experiment from Chapter 10. '
                      'Time Rocky\'s 3rd rotor (6³ = 216 ticks) to reach one full lap. '
                      'Target Earth duration: 511.0 seconds (8m 31s).',
                      style: TextStyle(
                        fontSize: 12,
                        color: EridianTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Dual Readout: Earth Stopwatch vs Eridian Ticks
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      label: 'EARTH STOPWATCH',
                      value: _formatStopwatch(_stopwatch.elapsedEarthDuration),
                      subtitle:
                          '${_stopwatch.elapsedEarthSeconds.toStringAsFixed(1)}s elapsed',
                      color: EridianTheme.petrovaCyan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      label: 'ERIDIAN TICKS',
                      value: '${eridianTime.ticks} ticks',
                      subtitle: 'Target: 216 (Rotor 3 lap)',
                      color: isGraceMilestoneHit
                          ? EridianTheme.emeraldLight
                          : EridianTheme.textPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // The Mechanical Rotors
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: EridianTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isGraceMilestoneHit
                        ? EridianTheme.emeraldGlow
                        : EridianTheme.border,
                    width: isGraceMilestoneHit ? 2 : 1.5,
                  ),
                  boxShadow: EridianTheme.cardShadow,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(EridianConstants.rotorCount, (
                      index,
                    ) {
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

              // Controls
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: _toggleStartPause,
                    icon: Icon(
                      _stopwatch.state == EridianStopwatchState.running
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    label: Text(
                      _stopwatch.state == EridianStopwatchState.running
                          ? 'Pause'
                          : 'Start Experiment',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          _stopwatch.state == EridianStopwatchState.running
                          ? EridianTheme.surfaceElevated
                          : EridianTheme.emeraldGlow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: EridianTheme.textSecondary,
                      side: const BorderSide(color: EridianTheme.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  // Quick warp button to jump near the 216 tick mark
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _stopwatch.stepTicks(210);
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: EridianTheme.petrovaCyan,
                      side: const BorderSide(color: EridianTheme.petrovaCyan),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Jump to 210 Ticks'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EridianTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EridianTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: EridianTheme.textMuted,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: EridianTheme.textMuted),
          ),
        ],
      ),
    );
  }

  String _formatStopwatch(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    final millis = (d.inMilliseconds % 1000) ~/ 100;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$millis';
  }
}
