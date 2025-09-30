import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wearos_app/widgets/routine_tile.dart';
import 'package:wearos_app/widgets/work_start_tile.dart';
import 'workout/workout_screen.dart'; // 이동할 화면

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class Routine {
  final int missionId;
  final String category;
  final bool isWorkout; // 운동 여부 플래그

  Routine({
    required this.missionId,
    required this.category,
    this.isWorkout = false,
  });
}

class _MainScreenState extends State<MainScreen> {
  // 체크 상태(일반 루틴용)
  final Map<int, bool> _checked = {};

  // 배경 박스 컬러(순환)
  static const List<Color> _boxColors = [
    Color(0xFFE5FFFE), // 민트
    Color(0xFFFFF9E5), // 연노랑
    Color(0xFFFFE5F8), // 연핑크
  ];

  // 루틴 예시 (러닝/걷기는 isWorkout: true)
  final List<Routine> routines = [
    Routine(missionId: 1, category: '✅ 아침 컨디션 체크'),
    Routine(missionId: 2, category: '🌞 오전에 창문 열기'),
    Routine(missionId: 3, category: '🏃 10분 러닝하기', isWorkout: true),
    Routine(missionId: 4, category: '💧 물 한 컵 마시기'),
    Routine(missionId: 5, category: '🚶 10분 걷기', isWorkout: true),
  ];

  // 3개씩 페이지
  static const int _pageSize = 3;
  int get _pageCount => (routines.length / _pageSize).ceil();

  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _startAutoPaging();
  }

  void _startAutoPaging() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % _pageCount;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _handleCheck(Routine routine, bool val) {
    HapticFeedback.mediumImpact();
    setState(() {
      _checked[routine.missionId] = val;
    });

    final completedCount = _checked.values.where((v) => v).length;
    final allDone = completedCount == routines.length;

    _showMiniDialog(
      allDone ? '🎊 모든 루틴을 완료했어요!' : '🎉 $completedCount개 완료했어요!',
    );
  }

  void _showMiniDialog(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (_) => Center(
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Text(
            message,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    });
  }

  // 현재 페이지의 3개 루틴 슬라이스
  List<Routine> _sliceRoutines(int page) {
    final start = page * _pageSize;
    final end = (start + _pageSize).clamp(0, routines.length);
    return routines.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    // 화면 전체는 심플하게, 중앙에 원형 카드 배치
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 탭하면 다음 페이지로
              final next = (_currentPage + 1) % _pageCount;
              _pageController.animateToPage(
                next,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
            },
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '긍정의 하루 보내기✨',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 상단 페이지 인디케이터
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pageCount, (i) {
                        final active = i == _currentPage;
                        return GestureDetector(
                          onTap: () {
                            if (_pageController.hasClients) {
                              _pageController.animateToPage(
                                i,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 14 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF76FF03)
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 5),

                    // 페이지 뷰 (각 페이지 안은 스크롤 가능)
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _pageCount,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (_, page) {
                          final slice = _sliceRoutines(page);

                          return ListView.separated(
                            padding: const EdgeInsets.only(top: 2, bottom: 4),
                            physics: const BouncingScrollPhysics(),
                            itemCount: slice.length,
                            itemBuilder: (_, i) {
                              final r = slice[i];
                              final bg = _boxColors[i % _boxColors.length];

                              if (r.isWorkout) {
                                // 러닝/걷기: 체크박스 대신 > 아이콘, 탭하면 왼쪽으로 슬라이드 → 오른쪽에 '시작하기'
                                return WorkoutStartTile(
                                  background: bg,
                                  text: r.category,
                                  onStart: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const WorkoutScreen(),
                                      ),
                                    );
                                  },
                                );
                              }

                              // 일반 루틴: 기존 체크 타일
                              return RoutineTile(
                                background: bg,
                                text: r.category,
                                checked: _checked[r.missionId] ?? false,
                                onChanged: (v) => _handleCheck(r, v ?? false),
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 4),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
