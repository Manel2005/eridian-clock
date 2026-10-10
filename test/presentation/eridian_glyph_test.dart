// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eridian_clock/presentation/widgets/eridian_glyph.dart';

void main() {
  group('EridianGlyph Widget', () {
    testWidgets('renders all 6 digits without error', (WidgetTester tester) async {
      for (int d = 0; d < 6; d++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EridianGlyph(digit: d, size: 48),
            ),
          ),
        );
        expect(find.byType(EridianGlyph), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
      }
    });

    test('throws assertion error for invalid digits', () {
      expect(() => EridianGlyph(digit: -1), throwsAssertionError);
      expect(() => EridianGlyph(digit: 6), throwsAssertionError);
    });
  });
}
