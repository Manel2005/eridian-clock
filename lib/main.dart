// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants.dart';
import 'core/eridian_time.dart';
import 'presentation/theme/eridian_theme.dart';
import 'presentation/widgets/clock_display.dart';
import 'presentation/widgets/converter_view.dart';
import 'presentation/widgets/focus_clock_view.dart';
import 'presentation/widgets/lore_dialog.dart';
import 'presentation/widgets/stopwatch_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EridianClockApp());
}

/// Root application widget.
class EridianClockApp extends StatelessWidget {
  const EridianClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eridian Clock',
      debugShowCheckedModeBanner: false,
      theme: EridianTheme.darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}

/// Primary container screen with bottom navigation, tabs, and ambient Focus Mode.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedTabIndex = 0;
  bool _isFocusMode = false;
  final FocusNode _keyboardFocusNode = FocusNode();

  // Clock State
  late EridianTime _currentTime;
  Timer? _clockTicker;
  bool _isRealtime = true;
  double _speedMultiplier = 1.0;
  double _subTickFraction = 0.0;
  DateTime _lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _syncWithRealTime();
    _startClockTicker();
  }

  void _startClockTicker() {
    _clockTicker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final now = DateTime.now();
      final dt = now.difference(_lastUpdate).inMicroseconds / 1000000.0;
      _lastUpdate = now;

      if (_isRealtime) {
        setState(() {
          _syncWithRealTime();
        });
      } else if (_speedMultiplier > 0) {
        // Fast-forward / simulated mode
        _subTickFraction +=
            (dt * _speedMultiplier) / EridianConstants.earthSecondsPerTick;
        if (_subTickFraction >= 1.0) {
          final int wholeTicks = _subTickFraction.floor();
          _subTickFraction -= wholeTicks;
          setState(() {
            _currentTime = _currentTime.addTicks(wholeTicks);
          });
        }
      }
    });
  }

  void _syncWithRealTime() {
    final now = DateTime.now();
    _currentTime = EridianTime.fromDateTime(now);
  }

  void _stepOneTick() {
    setState(() {
      _isRealtime = false;
      _currentTime = _currentTime.addTicks(1);
    });
  }

  void _toggleRealtime() {
    setState(() {
      _isRealtime = !_isRealtime;
      if (_isRealtime) {
        _speedMultiplier = 1.0;
        _syncWithRealTime();
      }
    });
  }

  void _setSpeed(double speed) {
    setState(() {
      _speedMultiplier = speed;
      if (speed != 1.0) {
        _isRealtime = false;
      }
    });
  }

  @override
  void dispose() {
    _clockTicker?.cancel();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If in Focus Mode, render the fullscreen ambient clock view exclusively
    if (_isFocusMode) {
      return KeyboardListener(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.escape ||
                  event.logicalKey == LogicalKeyboardKey.keyF)) {
            setState(() {
              _isFocusMode = false;
            });
          }
        },
        child: FocusClockView(
          eridianTime: _currentTime,
          onExit: () {
            setState(() {
              _isFocusMode = false;
            });
          },
        ),
      );
    }

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.keyF) {
          setState(() {
            _isFocusMode = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: EridianTheme.emeraldGlow,
                  boxShadow: EridianTheme.glowShadow,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'ERIDIAN CLOCK',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: EridianTheme.textPrimary,
                ),
              ),
            ],
          ),
          actions: [
            // Fullscreen Focus Mode toggle
            IconButton(
              icon: const Icon(Icons.fullscreen, size: 22),
              color: EridianTheme.petrovaCyan,
              tooltip: 'Focus Mode (F)',
              onPressed: () {
                setState(() {
                  _isFocusMode = true;
                });
              },
            ),
            // Lore Documentation Dialog
            IconButton(
              icon: const Icon(Icons.info_outline, size: 20),
              color: EridianTheme.textSecondary,
              tooltip: 'Novel Science & Lore',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const LoreDialog(),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IndexedStack(
          index: _selectedTabIndex,
          children: [
            // Tab 0: Primary Mechanical Clock
            ClockDisplay(
              eridianTime: _currentTime,
              isRealtime: _isRealtime,
              onStepTick: _stepOneTick,
              onToggleRealtime: _toggleRealtime,
              currentSpeed: _speedMultiplier,
              onSpeedChanged: _setSpeed,
              onEnterFocusMode: () {
                setState(() {
                  _isFocusMode = true;
                });
              },
            ),

            // Tab 1: Two-Way Converter
            const ConverterView(),

            // Tab 2: Chapter 10 Experiment Stopwatch
            const StopwatchView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: EridianTheme.borderSubtle)),
          ),
          child: NavigationBar(
            selectedIndex: _selectedTabIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            backgroundColor: EridianTheme.surface,
            indicatorColor: EridianTheme.surfaceElevated,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.access_time),
                selectedIcon: Icon(
                  Icons.access_time_filled,
                  color: EridianTheme.emeraldGlow,
                ),
                label: 'Clock',
              ),
              NavigationDestination(
                icon: Icon(Icons.swap_horiz),
                selectedIcon: Icon(
                  Icons.swap_horiz,
                  color: EridianTheme.petrovaCyan,
                ),
                label: 'Converter',
              ),
              NavigationDestination(
                icon: Icon(Icons.science_outlined),
                selectedIcon: Icon(
                  Icons.science,
                  color: EridianTheme.emeraldGlow,
                ),
                label: 'Experiment',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
