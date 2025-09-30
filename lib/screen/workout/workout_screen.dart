import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'run_screen.dart';
import 'walk_screen.dart';
import 'today_summary_screen.dart'; // 오늘의 총합 페이지
import '../../routes/bottom_slide_route.dart'; // 아래→위 슬라이드 전환

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  void _openTodaySummary(BuildContext context) {
    // TODO: 실제 서버/저장소 값으로 교체
    const bool hasData = true; // 테스트용

    final data = hasData
        ? TodaySummaryData(
            totalElapsed: const Duration(minutes: 40, seconds: 50),
            totalKm: 14.2,
            totalKcal: 730,
            walk: const WalkEntry(steps: 8260, km: 5.6, kcal: 280),
            run: const RunEntry(pace: "6'32''", km: 8.6, kcal: 450),
          )
        : const TodaySummaryData(
            totalElapsed: Duration.zero,
            totalKm: 0,
            totalKcal: 0,
          );

    Navigator.of(
      context,
    ).push(BottomSlidePageRoute(child: TodaySummaryScreen(data: data)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.shortestSide < 300;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              const Text(
                '운동을 선택해주세요',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              // 가운데 선택 카드
              Row(
                children: [
                  Expanded(
                    child: _WorkoutChoiceCard(
                      color: const Color(0xFFFFC7C7), // 연핑크
                      assetPath: 'assets/workout/direction_run.png',
                      label: '달리기',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RunScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _WorkoutChoiceCard(
                      color: const Color(0xFFC7FFF4), // 민트
                      assetPath: 'assets/workout/direction_walk.png',
                      label: '걷기',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const WalkScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // 하단 메뉴 (탭 → 오늘의 운동기록 페이지 슬라이드 업)
              Padding(
                padding: EdgeInsets.only(bottom: isSmall ? 2 : 6),
                child: Opacity(
                  opacity: 0.9,
                  child: GestureDetector(
                    onTap: () => _openTodaySummary(context),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.drag_handle,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutChoiceCard extends StatelessWidget {
  final Color color;
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const _WorkoutChoiceCard({
    required this.color,
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.shortestSide < 300;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isSmall ? 120 : 130,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: isSmall ? 44 : 52,
              height: isSmall ? 44 : 52,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontSize: isSmall ? 14 : 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
