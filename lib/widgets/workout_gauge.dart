import 'dart:math' as math;
import 'package:flutter/material.dart';

class WorkoutGauge extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final Color arcColor;
  final Color backgroundColor;
  final Widget center; // 중앙에 배치할 내용(시간/수치 등)
  final double size; // 지름(px)
  final double stroke; // 두께

  const WorkoutGauge({
    super.key,
    required this.progress,
    required this.arcColor,
    required this.center,
    this.backgroundColor = Colors.black,
    this.size = 220,
    this.stroke = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 검은 원 디스크
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 8),
              ],
            ),
          ),
          // 반원 아크
          CustomPaint(
            size: Size(size, size),
            painter: _ArcPainter(
              progress: progress.clamp(0.0, 1.0),
              arcColor: arcColor,
              stroke: stroke,
            ),
          ),
          // 중앙 콘텐츠
          center,
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color arcColor;
  final double stroke;

  _ArcPainter({
    required this.progress,
    required this.arcColor,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2 - stroke;

    final basePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // 반원 기준 각도 (위가 아니라 위쪽 반원 느낌을 위해 180도만 사용)
    final startAngle = math.pi; // 왼쪽 끝부터
    final sweepBase = math.pi * 0.90; // 배경 반원(조금 짧게)
    final sweepArc = sweepBase * progress;

    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // 배경 반원
    canvas.drawArc(
      arcRect,
      startAngle + math.pi * 0.05,
      sweepBase,
      false,
      basePaint,
    );

    // 진행 반원
    canvas.drawArc(
      arcRect,
      startAngle + math.pi * 0.05,
      sweepArc,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        arcColor != oldDelegate.arcColor ||
        stroke != oldDelegate.stroke;
  }
}
