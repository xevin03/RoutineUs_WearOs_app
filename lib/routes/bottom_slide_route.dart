import 'package:flutter/material.dart';

class BottomSlidePageRoute<T> extends PageRouteBuilder<T> {
  BottomSlidePageRoute({required Widget child})
    : super(
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (_, anim, __, child) {
          final offset = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(anim);
          return SlideTransition(position: offset, child: child);
        },
        opaque: false, // 뒤가 비쳐서 "떠오르는" 느낌
        barrierColor: Colors.black38,
      );
}
