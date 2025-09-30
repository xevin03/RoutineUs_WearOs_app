import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 원 오른쪽 가장자리 쪽에만 보이는 사이드 아크
class SummarySideArcPainter extends CustomPainter {
  final Color color;
  final double thickness;

  /// 시작 각도(라디안). 0은 오른쪽(+X), 시계방향 양수.
  /// 기본: 윗부분보다 살짝 오른쪽에서 시작해서 → 아래쪽 오른쪽 직전까지
  final double startAngle;
  final double sweepAngle;

  SummarySideArcPainter({
    required this.color,
    required this.thickness,
    double? startAngle,
    double? sweepAngle,
  }) : startAngle = startAngle ?? (-math.pi / 2 + math.pi * 0.12), // 위에서 조금 오른쪽
       sweepAngle = sweepAngle ?? (math.pi * 0.55); // 약 133도 (오른쪽면만)

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    // 스트로크가 잘리지 않도록 안쪽으로 살짝 여유
    final inset = thickness / 2 + 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );

    // 오른쪽 측면에만 보이는 아크
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant SummarySideArcPainter old) {
    return color != old.color ||
        thickness != old.thickness ||
        startAngle != old.startAngle ||
        sweepAngle != old.sweepAngle;
  }
}
