import 'package:flutter/material.dart';

class RoutineTile extends StatelessWidget {
  final Color background;
  final String text;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const RoutineTile({
    super.key,
    required this.background,
    required this.text,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onChanged(!checked),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: checked ? const Color(0xFF00E676) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked
                      ? const Color(0xFF00E676)
                      : const Color(0xFFD9D9D9),
                  width: 1.1,
                ),
                boxShadow: checked
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00E676).withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
