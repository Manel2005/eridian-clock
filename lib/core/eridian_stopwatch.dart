// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'constants.dart';
import 'eridian_time.dart';

/// State of the Eridian experiment stopwatch.
enum EridianStopwatchState { initial, running, paused }

/// An experiment stopwatch recreating Ryland Grace's measurement in Chapter 10.
///
/// Tracks elapsed Earth milliseconds alongside elapsed Eridian ticks,
/// allowing the user to observe the rotor progression in real time or
/// at simulated accelerated speeds.
class EridianStopwatch {
  int _elapsedEarthMicroseconds = 0;
  DateTime? _lastTimestamp;
  EridianStopwatchState _state = EridianStopwatchState.initial;

  /// Current playback/simulation speed multiplier (1x, 6x, 36x, 216x).
  double speedMultiplier;

  EridianStopwatch({this.speedMultiplier = 1.0});

  /// Current state of the stopwatch.
  EridianStopwatchState get state => _state;

  /// Total elapsed Earth duration.
  Duration get elapsedEarthDuration =>
      Duration(microseconds: _elapsedEarthMicroseconds);

  /// Total elapsed Earth seconds as a decimal.
  double get elapsedEarthSeconds => _elapsedEarthMicroseconds / 1000000.0;

  /// Equivalent Eridian time based on the elapsed duration.
  EridianTime get eridianTime =>
      EridianTime.fromEarthDuration(elapsedEarthDuration);

  /// Starts or resumes the stopwatch.
  void start() {
    if (_state != EridianStopwatchState.running) {
      _lastTimestamp = DateTime.now();
      _state = EridianStopwatchState.running;
    }
  }

  /// Pauses the stopwatch.
  void pause() {
    if (_state == EridianStopwatchState.running) {
      _updateElapsed();
      _state = EridianStopwatchState.paused;
      _lastTimestamp = null;
    }
  }

  /// Resets the stopwatch to zero.
  void reset() {
    _elapsedEarthMicroseconds = 0;
    _lastTimestamp = null;
    _state = EridianStopwatchState.initial;
  }

  /// Advances the stopwatch according to elapsed real time multiplied by [speedMultiplier].
  void update() {
    if (_state == EridianStopwatchState.running) {
      _updateElapsed();
    }
  }

  /// Manually steps forward by a specific number of Eridian ticks.
  void stepTicks(int count) {
    final double addedSeconds = count * EridianConstants.earthSecondsPerTick;
    _elapsedEarthMicroseconds += (addedSeconds * 1000000.0).round();
  }

  void _updateElapsed() {
    if (_lastTimestamp == null) return;
    final now = DateTime.now();
    final deltaMicroseconds = now.difference(_lastTimestamp!).inMicroseconds;
    _lastTimestamp = now;
    _elapsedEarthMicroseconds += (deltaMicroseconds * speedMultiplier).round();
  }
}
