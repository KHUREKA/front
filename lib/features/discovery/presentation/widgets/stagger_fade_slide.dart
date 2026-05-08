import 'package:flutter/material.dart';

/// 발견 플로우 각 단계에서 제목 → 소제목 → 콘텐츠 순으로
/// fade + 살짝 위로 슬라이드 등장시키는 헬퍼.
///
/// 컨트롤러 0..1 진행 중 [interval] 구간에서 자식이 등장한다.
class StaggerFadeSlide extends StatelessWidget {
  const StaggerFadeSlide({
    super.key,
    required this.controller,
    required this.interval,
    required this.child,
    this.slideDistance = 0.18,
  });

  final AnimationController controller;
  final Interval interval;
  final Widget child;

  /// 0..1 (Offset 단위 — Slide 전환 거리). 기본 0.18 ≈ 12-16px 정도.
  final double slideDistance;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: controller, curve: interval);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, slideDistance),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
