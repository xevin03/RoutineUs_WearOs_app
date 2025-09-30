import 'package:flutter/material.dart';
import 'widgets/summary_arc.dart';

class TodaySummaryData {
  final Duration totalElapsed;
  final double totalKm;
  final int totalKcal;
  final WalkEntry? walk;
  final RunEntry? run;

  const TodaySummaryData({
    required this.totalElapsed,
    required this.totalKm,
    required this.totalKcal,
    this.walk,
    this.run,
  });

  bool get isEmpty =>
      (walk == null && run == null) ||
      (totalElapsed.inSeconds == 0 && totalKm == 0 && totalKcal == 0);
}

class WalkEntry {
  final int steps;
  final double km;
  final int kcal;
  const WalkEntry({required this.steps, required this.km, required this.kcal});
}

class RunEntry {
  final String pace; // e.g. 6'32''
  final double km;
  final int kcal;
  const RunEntry({required this.pace, required this.km, required this.kcal});
}

class TodaySummaryScreen extends StatelessWidget {
  final TodaySummaryData data;
  const TodaySummaryScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diameter = (size.shortestSide - 6).clamp(240.0, 320.0);

    const base = 300.0;
    final s = (diameter / base);

    double fs(double v, {double min = 9, double max = 28}) =>
        (v * s).clamp(min, max);
    double sp(double v) => (v * s).clamp(1, 14);

    const purple = Color(0xFFDA6BFF);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: diameter,
          height: diameter,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 오른쪽 사이드 아크
              Positioned.fill(
                child: CustomPaint(
                  painter: SummarySideArcPainter(
                    color: purple,
                    thickness: (8.0 * s).clamp(5.0, 9.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(sp(12), sp(8), sp(12), sp(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.drag_handle,
                          color: Colors.white70,
                          size: fs(14, min: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: sp(2)),
                    Text(
                      '오늘의 운동기록',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: fs(10, min: 10, max: 12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: sp(6)),

                    // 총 시간
                    SizedBox(
                      height: fs(32, min: 30, max: 34),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formatElapsed(data.totalElapsed),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fs(32, min: 28, max: 34),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: sp(2)),

                    // 총 km / 총 kcal — 가운데 정렬
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sp(2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _miniStat(_km(data.totalKm), 'km', fs: fs),
                          SizedBox(width: sp(12)), // 두 값 사이만 살짝 띄움
                          _miniStat('${data.totalKcal}', 'kcal', fs: fs),
                        ],
                      ),
                    ),
                    SizedBox(height: sp(6)),

                    // 내용
                    Expanded(
                      child: data.isEmpty
                          ? Center(
                              child: Text(
                                '운동 기록이 존재하지 않습니다',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: fs(11, min: 9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (data.walk != null)
                                  _entryBlock(
                                    iconPath:
                                        'assets/workout/direction_walk.png',
                                    tint: const Color(0xFF76FFE4),
                                    title: '걷기',
                                    v1: '${_comma(data.walk!.steps)}보',
                                    v2: '${_km(data.walk!.km)}km',
                                    v3: '${data.walk!.kcal}kcal',
                                    fs: fs,
                                    sp: sp,
                                  ),
                                if (data.run != null)
                                  _entryBlock(
                                    iconPath:
                                        'assets/workout/direction_run.png',
                                    tint: const Color(0xFFFF9EB3),
                                    title: '달리기',
                                    v1: data.run!.pace,
                                    v2: '${_km(data.run!.km)}km',
                                    v3: '${data.run!.kcal}kcal',
                                    fs: fs,
                                    sp: sp,
                                  ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== 작은 컴포넌트들 =====

  static Widget _miniStat(
    String v,
    String u, {
    required double Function(double, {double min, double max}) fs,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          v,
          style: TextStyle(
            color: Colors.white,
            fontSize: fs(14, min: 11, max: 16), // 살짝 키움
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(width: fs(3, min: 2, max: 4)),
        Text(
          u,
          style: TextStyle(
            color: Colors.white70,
            fontSize: fs(11, min: 9, max: 12), // 살짝 키움
          ),
        ),
      ],
    );
  }

  /// 한 블록(아이콘 + 제목 + 값 3개)
  static Widget _entryBlock({
    required String iconPath,
    required Color tint,
    required String title,
    required String v1,
    required String v2,
    required String v3,
    required double Function(double, {double min, double max}) fs,
    required double Function(double) sp,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: sp(3)), // 블록 사이 더 촘촘
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘(조금 키움)
          Padding(
            padding: EdgeInsets.only(top: sp(1.5)),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(tint, BlendMode.srcATop),
              child: Image.asset(
                iconPath,
                width: fs(20, min: 16, max: 22),
                height: fs(20, min: 16, max: 22),
              ),
            ),
          ),
          SizedBox(width: sp(6)),
          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fs(13, min: 11, max: 14), // 제목 살짝 키움
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: sp(1.5)), // 제목-값 사이 더 촘촘
                // 값 3개 — 간격 줄이고 글씨 살짝 키움
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        v1,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: fs(12, min: 10, max: 13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: sp(4)),
                    Expanded(
                      child: Text(
                        v2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: fs(12, min: 10, max: 13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: sp(4)),
                    Expanded(
                      child: Text(
                        v3,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: fs(12, min: 10, max: 13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== 유틸 =====
  static String _formatElapsed(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  static String _km(double v) => v.toStringAsFixed(1);
  static String _comma(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
}
