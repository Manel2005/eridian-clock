// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'constants.dart';

/// Represents a point in time according to the Eridian timekeeping system.
///
/// An Eridian day (Sol) consists of 7,776 Eridian seconds (ticks) numbered
/// from 0 to 7,775, displayed across 5 base-6 rotating cylinders.
class EridianTime {
  /// The current tick within the Eridian day: 0 <= [ticks] < 7776.
  final int ticks;

  /// The Eridian Sol (day number), starting from 0.
  final int sol;

  /// Creates an [EridianTime] instance for a specific [ticks] and [sol].
  const EridianTime({
    required this.ticks,
    this.sol = 0,
  })  : assert(ticks >= 0 && ticks < EridianConstants.ticksPerDay,
            'Ticks must be between 0 and ${EridianConstants.ticksPerDay - 1}');

  /// Creates an [EridianTime] from an accumulated count of total ticks since epoch.
  factory EridianTime.fromTotalTicks(int totalTicks) {
    if (totalTicks < 0) {
      throw ArgumentError.value(
          totalTicks, 'totalTicks', 'Total ticks must be non-negative');
    }
    final int sol = totalTicks ~/ EridianConstants.ticksPerDay;
    final int ticks = totalTicks % EridianConstants.ticksPerDay;
    return EridianTime(ticks: ticks, sol: sol);
  }

  /// Converts an Earth [Duration] into [EridianTime].
  ///
  /// For instance, passing the duration elapsed since midnight converts
  /// the Earth day progress into Eridian ticks.
  factory EridianTime.fromEarthDuration(Duration duration) {
    final double totalEarthSeconds = duration.inMicroseconds / 1000000.0;
    if (totalEarthSeconds < 0) {
      throw ArgumentError.value(
          duration, 'duration', 'Duration must be non-negative');
    }

    // Add a microsencond epsilon (1e-6 seconds) to protect against
    // IEEE-754 floating point precision loss and integer microsecond truncation.
    const double epsilonSeconds = 1e-6;
    final int totalTicks =
        ((totalEarthSeconds + epsilonSeconds) / EridianConstants.earthSecondsPerTick).floor();
    return EridianTime.fromTotalTicks(totalTicks);
  }

  /// Converts a standard Earth [DateTime] to [EridianTime] based on the
  /// time elapsed since midnight (00:00:00) of that day.
  factory EridianTime.fromDateTime(DateTime dateTime) {
    final Duration sinceMidnight = Duration(
      hours: dateTime.hour,
      minutes: dateTime.minute,
      seconds: dateTime.second,
      milliseconds: dateTime.millisecond,
      microseconds: dateTime.microsecond,
    );
    return EridianTime.fromEarthDuration(sinceMidnight);
  }

  /// Returns the 5 base-6 digits [d4, d3, d2, d1, d0] representing the 5
  /// mechanical rotors from left (most significant, 6^4) to right (least significant, 6^0).
  ///
  /// Each digit is an integer in the range 0..5.
  List<int> toDigits() {
    int remaining = ticks;
    final List<int> digits = List<int>.filled(EridianConstants.rotorCount, 0);

    for (int i = EridianConstants.rotorCount - 1; i >= 0; i--) {
      digits[i] = remaining % EridianConstants.base;
      remaining ~/= EridianConstants.base;
    }

    return digits;
  }

  /// Returns the 5 Eridian character glyphs for the 5 mechanical rotors
  /// from most significant (left) to least significant (right).
  List<String> toGlyphs() {
    return toDigits().map((digit) => EridianConstants.glyphs[digit]).toList();
  }

  /// Returns the base-6 numerical string representation (e.g. "00000" to "55555").
  String toBase6String() {
    return toDigits().join('');
  }

  /// Returns the string formatted with Eridian numeral glyphs (e.g. "ℓℓℓℓℓ" to "∀∀∀∀∀").
  String toGlyphString() {
    return toGlyphs().join('');
  }

  /// Returns the elapsed fraction of the current Eridian day as a double in [0.0, 1.0).
  double get dayProgress => ticks / EridianConstants.ticksPerDay;

  /// Converts the current [ticks] into an Earth [Duration].
  Duration toEarthDuration() {
    final double earthSeconds = ticks * EridianConstants.earthSecondsPerTick;
    final int microseconds = (earthSeconds * 1000000.0).round();
    return Duration(microseconds: microseconds);
  }

  /// Returns a new [EridianTime] with [count] ticks added.
  /// Correctly handles rollover across Eridian day boundaries.
  EridianTime addTicks(int count) {
    final int totalTicks = (sol * EridianConstants.ticksPerDay) + ticks + count;
    return EridianTime.fromTotalTicks(totalTicks);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EridianTime &&
          runtimeType == other.runtimeType &&
          ticks == other.ticks &&
          sol == other.sol;

  @override
  int get hashCode => Object.hash(ticks, sol);

  @override
  String toString() =>
      'EridianTime(sol: $sol, ticks: $ticks, base6: ${toBase6String()}, glyphs: ${toGlyphString()})';
}
