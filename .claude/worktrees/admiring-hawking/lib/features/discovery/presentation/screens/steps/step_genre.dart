import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../home/domain/performance_genre.dart';
import '../../providers/discovery_filter_provider.dart';
import '../../widgets/option_card.dart';
import '../../widgets/question_text.dart';
import '../../widgets/stagger_fade_slide.dart';

/// Q1. 어떤 공연이 보고 싶으세요?
///
/// - 6개 장르 다중선택 (2열 그리드)
/// - "상관없어요" 전체 폭 카드 — 누르면 즉시 다음으로 (장르 비움)
/// - [isActive] 가 true 가 되는 순간 cascade 애니메이션 재생
class StepGenre extends ConsumerStatefulWidget {
  const StepGenre({
    super.key,
    required this.onNext,
    this.isActive = true,
  });

  final VoidCallback onNext;
  final bool isActive;

  @override
  ConsumerState<StepGenre> createState() => _StepGenreState();
}

class _StepGenreState extends ConsumerState<StepGenre>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    if (widget.isActive) _ctrl.forward();
  }

  @override
  void didUpdateWidget(StepGenre old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _ctrl.forward(from: 0);
    } else if (!widget.isActive && old.isActive) {
      _ctrl.value = 0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(discoveryFilterProvider);
    final notifier = ref.read(discoveryFilterProvider.notifier);
    final selected = filter.genres.toSet();
    final canProceed = filter.genres.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          QuestionText(
            question: '어떤 공연이\n보고 싶으세요?',
            helper: '여러 개 골라도 돼요',
            animationController: _ctrl,
          ),
          const SizedBox(height: 32),

          // 장르 6개 — 2열
          StaggerFadeSlide(
            controller: _ctrl,
            interval: const Interval(0.40, 0.85, curve: Curves.easeOutCubic),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 165 / 72,
              children: [
                for (final g in PerformanceGenre.values)
                  OptionCard(
                    label: g.displayName,
                    emoji: g.emoji,
                    selected: selected.contains(g),
                    onTap: () => notifier.toggleGenre(g),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 전체 폭 "상관없어요"
          StaggerFadeSlide(
            controller: _ctrl,
            interval: const Interval(0.50, 0.95, curve: Curves.easeOutCubic),
            child: OptionCard(
              label: '상관없어요 — 전부 보여주세요',
              emoji: '✨',
              selected: false,
              fullWidth: true,
              onTap: () {
                notifier.clearGenres();
                widget.onNext();
              },
            ),
          ),

          const SizedBox(height: 32),

          // 다음 버튼
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: canProceed ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.textTertiary,
                textStyle: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text('다음'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
