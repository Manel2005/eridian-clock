// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eridian_clock/main.dart';
import 'package:eridian_clock/presentation/widgets/eridian_glyph.dart';
import 'package:eridian_clock/presentation/widgets/focus_clock_view.dart';
import 'package:eridian_clock/presentation/widgets/rotor_cylinder.dart';

void main() {
  testWidgets('EridianClockApp renders clock and navigation smoke test', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const EridianClockApp());
    await tester.pump();

    // Verify AppBar title is present
    expect(find.text('ERIDIAN CLOCK'), findsOneWidget);

    // Verify 5 rotor cylinders are rendered
    expect(find.byType(RotorCylinder), findsNWidgets(5));

    // Verify vector glyphs are rendered
    expect(find.byType(EridianGlyph), findsWidgets);

    // Verify bottom navigation bar destinations
    expect(find.text('Clock'), findsOneWidget);
    expect(find.text('Converter'), findsOneWidget);
    expect(find.text('Experiment'), findsOneWidget);

    // Switch to Converter tab
    await tester.tap(find.text('Converter'));
    await tester.pumpAndSettle();
    expect(find.text('EARTH TIME ➔ ERIDIAN TIME'), findsOneWidget);

    // Switch to Experiment tab
    await tester.tap(find.text('Experiment'));
    await tester.pumpAndSettle();
    expect(find.text('EXPERIMENT: ROTOR 3 LAP TIMING'), findsOneWidget);

    // Switch back to Clock tab
    await tester.tap(find.text('Clock'));
    await tester.pumpAndSettle();

    // Enter Focus Mode
    await tester.tap(find.byIcon(Icons.fullscreen).first);
    await tester.pumpAndSettle();

    // Verify FocusClockView is active (AppBar & NavigationBar are hidden)
    expect(find.byType(FocusClockView), findsOneWidget);
    expect(find.text('Clock'), findsNothing);
    expect(find.byIcon(Icons.fullscreen_exit), findsOneWidget);

    // Exit Focus Mode
    await tester.tap(find.byIcon(Icons.fullscreen_exit));
    await tester.pumpAndSettle();

    // Verify returned to standard navigation screen
    expect(find.byType(FocusClockView), findsNothing);
    expect(find.text('Clock'), findsOneWidget);
  });
}
