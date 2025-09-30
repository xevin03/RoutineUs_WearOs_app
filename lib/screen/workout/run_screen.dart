import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wearos_app/widgets/workout_gauge.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  Duration elapsed = Duration.zero;
  double distanceKm = 8.6; // TODO: 실제 러닝 거리
  int kcal = 450; // TODO: 실제 칼로리
  double progress = 0.65; // 0~1 (게이지)

  Timer? _timer;
  bool isRunning = false; // ✅ 처음엔 멈춤 상태

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => elapsed += const Duration(seconds: 1));
    });
    setState(() => isRunning = true);
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  void _toggleRun() => isRunning ? _pauseTimer() : _startTimer();

  String _formatPace() {
    final totalSec = 392; // 6분32초 (더미 pace)
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return "$m'${s.toString().padLeft(2, '0')}''";
  }

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFFF9EB3);
    final midText = TextStyle(
      color: Colors.white.withOpacity(0.85),
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF888888),
      body: SafeArea(
        child: Center(
          child: WorkoutGauge(
            size: 230,
            stroke: 16,
            progress: progress,
            arcColor: Color(0xffFFC4C4),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25), // ✅ WalkScreen과 동일한 간격
                Text(
                  _formatElapsed(elapsed),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5), // ✅ 동일 간격
                Text(
                  _formatPace(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34, // ✅ WalkScreen과 동일 크기
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'PACE',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${distanceKm.toStringAsFixed(1)}Km', style: midText),
                    const SizedBox(width: 16),
                    Text('${kcal}kcal', style: midText),
                  ],
                ),
                const SizedBox(height: 3), // ✅ 동일 간격
                // ✅ 재생/일시정지 토글 버튼
                IconButton(
                  onPressed: _toggleRun,
                  iconSize: 25, // ✅ WalkScreen과 동일 크기
                  icon: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatElapsed(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}
