// Copyright (c) 2026 Eridian Clock Contributors
// Open-source project inspired by Andy Weir's "Project Hail Mary".

import 'package:flutter/material.dart';

import '../theme/eridian_theme.dart';

/// A custom vector-rendered Eridian numeral glyph (0 through 5).
///
/// In Chapter 10 of "Project Hail Mary", the number of straight-line segments
/// in each symbol corresponds to its numerical value:
/// - 0: ℓ (a continuous curve/closed loop, 0 straight lines)
/// - 1: I (1 straight vertical segment)
/// - 2: V (2 straight line segments meeting at an angle)
/// - 3: λ (3 straight line segments, tripod/lambda shape)
/// - 4: + (4 straight line segments forming a junction)
/// - 5: ∀ (5 straight line segments forming an inverted enclosed shape)
class EridianGlyph extends StatelessWidget {
  /// The base-6 digit (0 through 5).
  final int digit;

  /// The size (width and height) of the glyph box.
  final double size;

  /// The stroke color.
  final Color color;

  /// The thickness of the stroke.
  final double strokeWidth;

  /// Whether to render a neon glow shadow behind the glyph.
  final bool glow;

  const EridianGlyph({
    super.key,
    required this.digit,
    this.size = 36.0,
    this.color = EridianTheme.emeraldLight,
    this.strokeWidth = 3.5,
    this.glow = true,
  }) : assert(digit >= 0 && digit <= 5, 'Digit must be between 0 and 5');

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _EridianGlyphPainter(
        digit: digit,
        color: color,
        strokeWidth: strokeWidth,
        glow: glow,
      ),
    );
  }
}

class _EridianGlyphPainter extends CustomPainter {
  final int digit;
  final Color color;
  final double strokeWidth;
  final bool glow;

  _EridianGlyphPainter({
    required this.digit,
    required this.color,
    required this.strokeWidth,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Coordinate boundaries
    final left = w * 0.22;
    final right = w * 0.78;
    final top = h * 0.16;
    final bottom = h * 0.84;
    final midX = w * 0.5;
    final midY = h * 0.5;

    // Main stroke paint
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Optional glow blur paint
    Paint? glowPaint;
    if (glow) {
      glowPaint = Paint()
        ..color = color.withValues(alpha: 0.45)
        ..strokeWidth = strokeWidth * 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    }

    void draw(void Function(Paint p) drawFn) {
      if (glowPaint != null) drawFn(glowPaint);
      drawFn(strokePaint);
    }

    switch (digit) {
      case 0:
        // 0: Continuous loop (0 straight line segments)
        draw((p) {
          final rect = Rect.fromCenter(
            center: Offset(midX, midY),
            width: w * 0.52,
            height: h * 0.68,
          );
          canvas.drawOval(rect, p);
        });
        break;

      case 1:
        // 1: Exactly 1 straight vertical segment
        draw((p) {
          canvas.drawLine(Offset(midX, top), Offset(midX, bottom), p);
        });
        break;

      case 2:
        // 2: Exactly 2 straight segments (chevron / V)
        draw((p) {
          final path = Path()
            ..moveTo(left, top)
            ..lineTo(midX, bottom)
            ..lineTo(right, top);
          canvas.drawPath(path, p);
        });
        break;

      case 3:
        // 3: Exactly 3 straight segments (Tripod / Lambda)
        draw((p) {
          final junctionY = midY * 0.75;
          final path = Path()
            ..moveTo(left, bottom)
            ..lineTo(midX, junctionY)
            ..lineTo(right, bottom);
          canvas.drawPath(path, p);
          canvas.drawLine(Offset(midX, junctionY), Offset(midX, top), p);
        });
        break;

      case 4:
        // 4: Exactly 4 straight segments (Cross / Plus)
        draw((p) {
          canvas.drawLine(Offset(left, midY), Offset(right, midY), p);
          canvas.drawLine(Offset(midX, top), Offset(midX, bottom), p);
        });
        break;

      case 5:
        // 5: Exactly 5 straight segments (Inverted A / closed chevron)
        draw((p) {
          final path = Path()
            ..moveTo(left, top)
            ..lineTo(midX, bottom)
            ..lineTo(right, top);
          canvas.drawPath(path, p);
          // Horizontal crossbar (line 4)
          canvas.drawLine(
            Offset(w * 0.33, h * 0.44),
            Offset(w * 0.67, h * 0.44),
            p,
          );
          // Top roof bar (line 5)
          canvas.drawLine(Offset(left, top), Offset(right, top), p);
        });
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _EridianGlyphPainter oldDelegate) {
    return oldDelegate.digit != digit ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.glow != glow;
  }
}
