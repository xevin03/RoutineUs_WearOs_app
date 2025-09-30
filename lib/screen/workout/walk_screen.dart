import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wearos_app/widgets/workout_gauge.dart';

class WalkScreen extends StatefulWidget {
  const WalkScreen({super.key});

  @override
  State<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  Duration elapsed = Duration.zero;
  int steps = 8620; // TODO: 실제 걸음수
  double distanceKm = 5.6; // TODO: 실제 거리
  int kcal = 280; // TODO: 실제 칼로리
  double progress = 0.72; // 0~1

  Timer? _timer;
  bool isRunning = false; // ✅ 처음엔 멈춤 상태

  @override
  void initState() {
    super.initState();
    // 초기 타이머 시작하지 않음
  }

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

  @override
  Widget build(BuildContext context) {
    final mint = const Color(0xFF9CF4E6);
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
            arcColor: Color(0xFFA5FFED),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Text(
                  _formatElapsed(elapsed),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$steps',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'STEPS',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 1.8,
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
                const SizedBox(height: 3),
                // ✅ 재생/일시정지 토글 버튼
                IconButton(
                  onPressed: _toggleRun,
                  iconSize: 25,
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
