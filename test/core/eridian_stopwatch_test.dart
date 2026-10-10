// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter_test/flutter_test.dart';
import 'package:eridian_clock/core/eridian_stopwatch.dart';

void main() {
  group('EridianStopwatch', () {
    test('initial state starts at 0', () {
      final stopwatch = EridianStopwatch();
      expect(stopwatch.state, equals(EridianStopwatchState.initial));
      expect(stopwatch.elapsedEarthDuration, equals(Duration.zero));
      expect(stopwatch.eridianTime.ticks, equals(0));
    });

    test('manual stepTicks advances ticks and elapsed duration', () {
      final stopwatch = EridianStopwatch();
      stopwatch.stepTicks(216);

      expect(stopwatch.eridianTime.ticks, equals(216));
      expect(stopwatch.elapsedEarthSeconds, closeTo(511.0, 0.05));
    });

    test('reset clears accumulated time', () {
      final stopwatch = EridianStopwatch();
      stopwatch.stepTicks(42);
      expect(stopwatch.eridianTime.ticks, equals(42));

      stopwatch.reset();
      expect(stopwatch.state, equals(EridianStopwatchState.initial));
      expect(stopwatch.eridianTime.ticks, equals(0));
      expect(stopwatch.elapsedEarthDuration, equals(Duration.zero));
    });
  });
}
