import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutStartTile extends StatefulWidget {
  final Color background;
  final String text;
  final VoidCallback onStart;

  const WorkoutStartTile({
    super.key,
    required this.background,
    required this.text,
    required this.onStart,
  });

  @override
  State<WorkoutStartTile> createState() => _WorkoutStartTileState();
}

class _WorkoutStartTileState extends State<WorkoutStartTile>
    with SingleTickerProviderStateMixin {
  static const double _reveal = 78; // 오른쪽 버튼이 보일 폭
  late final AnimationController _ac;
  late final Animation<double> _dx;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _dx = Tween<double>(
      begin: 0,
      end: -_reveal,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _ac.forward();
      HapticFeedback.selectionClick();
    } else {
      _ac.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          // 뒤쪽: '시작하기' 버튼 (오른쪽)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: widget.background,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 6),
              child: AnimatedBuilder(
                animation: _ac,
                builder: (_, __) => Opacity(
                  opacity: _ac.value, // 열릴수록 선명
                  child: GestureDetector(
                    onTap: widget.onStart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935), // 빨강 배경
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                      ),
                      child: const Text(
                        '시작하기',
                        style: TextStyle(
                          color: Colors.white, // 텍스트 화이트
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 앞쪽: 실제 내용 (탭하면 좌측 슬라이드)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _ac,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(_dx.value, 0), // 0 → -_reveal
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _toggle, // 탭하면 열기/닫기
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: widget.background,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                      ),
                      child: Row(
                        children: [
                          // 왼쪽 아이콘(운동 힌트)

                          // 텍스트
                          Expanded(
                            child: Text(
                              widget.text,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),

                          // 우측 > 아이콘 (체크박스 대신)
                          Opacity(
                            opacity: _open ? 0.3 : 0.9,
                            child: const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
