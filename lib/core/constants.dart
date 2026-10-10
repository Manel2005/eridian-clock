// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

/// Scientific and mathematical constants for the Eridian timekeeping system.
///
/// In Chapter 10 of Andy Weir's novel "Project Hail Mary", Ryland Grace
/// and Rocky establish a shared unit of time by measuring the rotation of
/// Rocky's mechanical clock.
abstract final class EridianConstants {
  /// The base of the Eridian numerical system (senary / base-6).
  ///
  /// Eridians have 5 radial limbs, but manipulate tools and count using
  /// two hands with 3 digits each, resulting in 6 digits (0 through 5).
  static const int base = 6;

  /// The number of mechanical cylinders/rotors on Rocky's clock.
  static const int rotorCount = 5;

  /// Total number of Eridian ticks in one full Eridian day (Sol).
  ///
  /// In base-6 with 5 rotors: 6^5 = 7,776 ticks (or 100000 in base-6).
  static const int ticksPerDay = 7776; // 6^5

  /// Earth seconds per Eridian second (tick).
  ///
  /// Grace timed the 3rd rotor (6^3 = 216 ticks) to make a full lap in
  /// exactly 511.0 Earth seconds:
  ///   511.0 / 216 = 2.3657407407407408... Earth seconds
  static const double earthSecondsPerTick = 511.0 / 216.0;

  /// Earth milliseconds per Eridian tick.
  static const double earthMillisPerTick = earthSecondsPerTick * 1000.0;

  /// Length of one full Eridian day in Earth seconds:
  ///   7776 * (511 / 216) = 18,396 Earth seconds (~5.11 hours).
  static const double eridianDayInEarthSeconds =
      ticksPerDay * earthSecondsPerTick;

  /// The six Eridian numeral glyphs for digits 0 through 5.
  ///
  /// Each glyph is formed by a number of straight-line segments equal to its
  /// numeric value (with 0 represented by a continuous loop):
  /// - 0: ℓ (loop, 0 straight line segments)
  /// - 1: I (1 straight line)
  /// - 2: V (2 straight lines)
  /// - 3: λ (3 straight lines, Greek lambda/tripod)
  /// - 4: + (4 straight lines)
  /// - 5: ∀ (5 straight lines, inverted A)
  static const List<String> glyphs = ['ℓ', 'I', 'V', 'λ', '+', '∀'];

  /// The tick value represented by each rotor position (from least significant
  /// Rotor 0 up to Rotor 4):
  /// - Rotor 0: 6^0 = 1 tick (~2.37s)
  /// - Rotor 1: 6^1 = 6 ticks (~14.2s)
  /// - Rotor 2: 6^2 = 36 ticks (~85.2s)
  /// - Rotor 3: 6^3 = 216 ticks (~511s, timed by Grace)
  /// - Rotor 4: 6^4 = 1296 ticks (~3066s ~ 51.1 min)
  static const List<int> rotorWeights = [1, 6, 36, 216, 1296];
}
