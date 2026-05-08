import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 빈 상태 일러스트 애니메이션 스타일.
///
/// - [bob] : 위아래 부드럽게 떠오름 (티켓이 두근두근 기다리는 느낌)
/// - [sway]: 좌우로 살랑살랑 흔들림 (행운/클로버)
/// - [wiggle]: 살짝 회전 + 살짝 커지기 (편지·우편함, 깃발이 펄럭이는 느낌)
/// - [none]: 정적 (기본 안전값)
enum EmptyAnimation { bob, sway, wiggle, none }

/// 탭별 비어있을 때 표시.
class EmptyStateView extends StatefulWidget {
  const EmptyStateView({
    super.key,
    required this.emoji,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.animation = EmptyAnimation.bob,
  });

  final String emoji;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EmptyAnimation animation;

  @override
  State<EmptyStateView> createState() => _EmptyStateViewState();
}

class _EmptyStateViewState extends State<EmptyStateView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    final ms = switch (widget.animation) {
      EmptyAnimation.bob => 2400,
      EmptyAnimation.sway => 1800,
      EmptyAnimation.wiggle => 1500,
      EmptyAnimation.none => 0,
    };
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms == 0 ? 1 : ms),
    );
    if (widget.animation != EmptyAnimation.none) {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emojiText =
        Text(widget.emoji, style: const TextStyle(fontSize: 80, height: 1));

    final Widget animated = widget.animation == EmptyAnimation.none
        ? emojiText
        : AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => _animate(_ctrl.value, child!),
            child: emojiText,
          );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            animated,
            const SizedBox(height: 24),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (widget.description != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.description!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (widget.onAction != null && widget.actionLabel != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: widget.onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    textStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(widget.actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 컨트롤러 값(0..1, reverse repeat 으로 0↔1 진동) → 변환 위젯.
  Widget _animate(double v, Widget child) {
    final t = Curves.easeInOut.transform(v); // 0..1
    switch (widget.animation) {
      case EmptyAnimation.bob:
        // 위아래 6px, 부드러운 등락.
        return Transform.translate(
          offset: Offset(0, -6 * t),
          child: child,
        );
      case EmptyAnimation.sway:
        // ±0.08 rad (≈ ±4.5°), 좌우 살랑살랑.
        final angle = (t - 0.5) * 0.16;
        return Transform.rotate(angle: angle, child: child);
      case EmptyAnimation.wiggle:
        // 살짝 회전 + 살짝 커지기.
        final angle = (t - 0.5) * 0.1; // ±0.05 rad
        final scale = 1 + t * 0.06; // 1.0 → 1.06
        return Transform.rotate(
          angle: angle,
          child: Transform.scale(scale: scale, child: child),
        );
      case EmptyAnimation.none:
        return child;
    }
  }
}
