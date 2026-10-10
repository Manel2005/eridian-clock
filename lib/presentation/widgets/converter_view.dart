// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/eridian_time.dart';
import '../theme/eridian_theme.dart';
import 'eridian_glyph.dart';

/// Interactive two-way converter between Earth time and Eridian time.
class ConverterView extends StatefulWidget {
  const ConverterView({super.key});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> {
  // Earth Input Controllers
  final TextEditingController _hoursController = TextEditingController(text: '12');
  final TextEditingController _minutesController = TextEditingController(text: '00');
  final TextEditingController _secondsController = TextEditingController(text: '00');

  // Eridian Input Controller
  final TextEditingController _ticksController = TextEditingController(text: '3888');

  EridianTime _convertedFromEarth = const EridianTime(ticks: 0);
  Duration _convertedFromTicks = Duration.zero;

  @override
  void initState() {
    super.initState();
    _recalculateFromEarth();
    _recalculateFromTicks();
  }

  void _recalculateFromEarth() {
    final h = int.tryParse(_hoursController.text) ?? 0;
    final m = int.tryParse(_minutesController.text) ?? 0;
    final s = int.tryParse(_secondsController.text) ?? 0;

    final duration = Duration(hours: h, minutes: m, seconds: s);
    setState(() {
      _convertedFromEarth = EridianTime.fromEarthDuration(duration);
    });
  }

  void _recalculateFromTicks() {
    final ticks = int.tryParse(_ticksController.text) ?? 0;
    final safeTicks = ticks.clamp(0, EridianConstants.ticksPerDay - 1);
    final time = EridianTime(ticks: safeTicks);
    setState(() {
      _convertedFromTicks = time.toEarthDuration();
    });
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _ticksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section 1: Earth Time -> Eridian Time
              _buildCard(
                title: 'EARTH TIME ➔ ERIDIAN TIME',
                subtitle: 'Convert hours, minutes, and seconds into Eridian Sols and ticks',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            controller: _hoursController,
                            label: 'Hours',
                            onChanged: (_) => _recalculateFromEarth(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildInputField(
                            controller: _minutesController,
                            label: 'Minutes',
                            onChanged: (_) => _recalculateFromEarth(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildInputField(
                            controller: _secondsController,
                            label: 'Seconds',
                            onChanged: (_) => _recalculateFromEarth(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: EridianTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: EridianTheme.borderSubtle),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Eridian Sol & Ticks:',
                                  style: TextStyle(color: EridianTheme.textMuted)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Sol ${_convertedFromEarth.sol}, Tick ${_convertedFromEarth.ticks}',
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    color: EridianTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Base-6 Digits:',
                                  style: TextStyle(color: EridianTheme.textMuted)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_convertedFromEarth.toBase6String()}₆',
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    color: EridianTheme.petrovaCyan,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _convertedFromEarth
                                .toDigits()
                                .map(
                                  (d) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: EridianGlyph(
                                      digit: d,
                                      size: 32,
                                      strokeWidth: 3.0,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section 2: Eridian Ticks -> Earth Time
              _buildCard(
                title: 'ERIDIAN TICKS ➔ EARTH TIME',
                subtitle: 'Convert Rocky\'s rotor tick count (0 to 7775) into Earth duration',
                child: Column(
                  children: [
                    _buildInputField(
                      controller: _ticksController,
                      label: 'Ticks (0 - 7775)',
                      onChanged: (_) => _recalculateFromTicks(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: EridianTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: EridianTheme.borderSubtle),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Equivalent Earth Duration:',
                              style: TextStyle(color: EridianTheme.textMuted)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatDuration(_convertedFromTicks),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: EridianTheme.emeraldLight,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EridianTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EridianTheme.border),
        boxShadow: EridianTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: EridianTheme.emeraldLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: EridianTheme.textMuted),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: const TextStyle(
        fontFamily: 'monospace',
        color: EridianTheme.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: EridianTheme.textMuted, fontSize: 12),
        filled: true,
        fillColor: EridianTheme.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EridianTheme.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EridianTheme.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EridianTheme.emeraldGlow),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return '${hours}h ${minutes}m ${seconds}s';
  }
}
