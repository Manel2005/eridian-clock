// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter_test/flutter_test.dart';
import 'package:eridian_clock/core/constants.dart';
import 'package:eridian_clock/core/eridian_time.dart';

void main() {
  group('EridianConstants', () {
    test('verifies mathematical constants from Chapter 10', () {
      expect(EridianConstants.base, equals(6));
      expect(EridianConstants.rotorCount, equals(5));
      expect(EridianConstants.ticksPerDay, equals(7776)); // 6^5

      // Ryland Grace's measurement of Rotor 3 (216 ticks in 511.0 Earth seconds)
      expect(EridianConstants.earthSecondsPerTick, closeTo(2.36574, 0.0001));

      // Length of Eridian Day in Earth seconds (~18396s = ~5.11 hours)
      expect(EridianConstants.eridianDayInEarthSeconds, closeTo(18396.0, 0.5));
    });

    test('verifies stroke-count glyphs', () {
      expect(EridianConstants.glyphs.length, equals(6));
      expect(EridianConstants.glyphs[0], equals('ℓ'));
      expect(EridianConstants.glyphs[1], equals('I'));
      expect(EridianConstants.glyphs[2], equals('V'));
      expect(EridianConstants.glyphs[3], equals('λ'));
      expect(EridianConstants.glyphs[4], equals('+'));
      expect(EridianConstants.glyphs[5], equals('∀'));
    });
  });

  group('EridianTime Base-6 Digit & Glyph Decomposition', () {
    test('tick 0 -> [0, 0, 0, 0, 0] -> ℓℓℓℓℓ', () {
      const time = EridianTime(ticks: 0);
      expect(time.toDigits(), equals([0, 0, 0, 0, 0]));
      expect(time.toBase6String(), equals('00000'));
      expect(time.toGlyphs(), equals(['ℓ', 'ℓ', 'ℓ', 'ℓ', 'ℓ']));
      expect(time.toGlyphString(), equals('ℓℓℓℓℓ'));
      expect(time.dayProgress, equals(0.0));
    });

    test('tick 1 -> [0, 0, 0, 0, 1] -> ℓℓℓℓI', () {
      const time = EridianTime(ticks: 1);
      expect(time.toDigits(), equals([0, 0, 0, 0, 1]));
      expect(time.toBase6String(), equals('00001'));
      expect(time.toGlyphString(), equals('ℓℓℓℓI'));
    });

    test('tick 6 (Rotor 1 advances) -> [0, 0, 0, 1, 0] -> ℓℓℓIℓ', () {
      const time = EridianTime(ticks: 6);
      expect(time.toDigits(), equals([0, 0, 0, 1, 0]));
      expect(time.toBase6String(), equals('00010'));
      expect(time.toGlyphString(), equals('ℓℓℓIℓ'));
    });

    test('tick 36 (Rotor 2 advances) -> [0, 0, 1, 0, 0] -> ℓℓIℓℓ', () {
      const time = EridianTime(ticks: 36);
      expect(time.toDigits(), equals([0, 0, 1, 0, 0]));
      expect(time.toBase6String(), equals('00100'));
      expect(time.toGlyphString(), equals('ℓℓIℓℓ'));
    });

    test('tick 216 (Rotor 3 - Grace stopwatch lap) -> [0, 1, 0, 0, 0] -> ℓIℓℓℓ', () {
      const time = EridianTime(ticks: 216);
      expect(time.toDigits(), equals([0, 1, 0, 0, 0]));
      expect(time.toBase6String(), equals('01000'));
      expect(time.toGlyphString(), equals('ℓIℓℓℓ'));
    });

    test('tick 1296 (Rotor 4 advances) -> [1, 0, 0, 0, 0] -> Iℓℓℓℓ', () {
      const time = EridianTime(ticks: 1296);
      expect(time.toDigits(), equals([1, 0, 0, 0, 0]));
      expect(time.toBase6String(), equals('10000'));
      expect(time.toGlyphString(), equals('Iℓℓℓℓ'));
    });

    test('tick 7775 (Maximum tick before rollover) -> [5, 5, 5, 5, 5] -> ∀∀∀∀∀', () {
      const time = EridianTime(ticks: 7775);
      expect(time.toDigits(), equals([5, 5, 5, 5, 5]));
      expect(time.toBase6String(), equals('55555'));
      expect(time.toGlyphString(), equals('∀∀∀∀∀'));
      expect(time.dayProgress, closeTo(7775 / 7776, 0.0001));
    });
  });

  group('EridianTime Arithmetic & Rollovers', () {
    test('rollover to next Eridian Sol', () {
      const endOfDay = EridianTime(ticks: 7775, sol: 0);
      final nextDay = endOfDay.addTicks(1);

      expect(nextDay.sol, equals(1));
      expect(nextDay.ticks, equals(0));
      expect(nextDay.toBase6String(), equals('00000'));
      expect(nextDay.toGlyphString(), equals('ℓℓℓℓℓ'));
    });

    test('large tick addition accumulates multiple Sols', () {
      const start = EridianTime(ticks: 0, sol: 0);
      final later = start.addTicks(7776 * 3 + 42);

      expect(later.sol, equals(3));
      expect(later.ticks, equals(42));
    });
  });

  group('Earth <-> Eridian Time Conversion', () {
    test('Grace stopwatch experiment: 511.0 Earth seconds converts to 216 ticks', () {
      final duration = Duration(microseconds: (511.0 * 1000000).round());
      final eridianTime = EridianTime.fromEarthDuration(duration);

      expect(eridianTime.ticks, equals(216));
      expect(eridianTime.toBase6String(), equals('01000'));
    });

    test('round-trip conversion preservation', () {
      for (final testTick in [0, 1, 6, 42, 216, 1296, 5000, 7775]) {
        final original = EridianTime(ticks: testTick);
        final earthDuration = original.toEarthDuration();
        final reconstructed = EridianTime.fromEarthDuration(earthDuration);

        expect(reconstructed.ticks, equals(testTick));
      }
    });
  });
}
