import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../home/domain/performance_genre.dart';
import '../../providers/discovery_filter_provider.dart';
import '../../widgets/option_card.dart';
import '../../widgets/question_text.dart';

/// Q1. 어떤 공연이 보고 싶으세요?
///
/// - 6개 장르 다중선택 (2열 그리드)
/// - "상관없어요" 전체 폭 카드 — 누르면 즉시 다음으로 (장르 비움)
/// - 다중선택 후 [onNext] 로 진행
class StepGenre extends ConsumerWidget {
  const StepGenre({
    super.key,
    required this.onNext,
  });

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          const QuestionText(
            question: '어떤 공연이\n보고 싶으세요?',
            helper: '여러 개 골라도 돼요',
          ),
          const SizedBox(height: 32),

          // 장르 6개 — 2열
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 165 / 72, // 가로/세로 비율
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

          const SizedBox(height: 16),

          // 전체 폭 "상관없어요"
          OptionCard(
            label: '상관없어요 — 전부 보여주세요',
            emoji: '✨',
            selected: false,
            fullWidth: true,
            onTap: () {
              notifier.clearGenres();
              onNext();
            },
          ),

          const SizedBox(height: 32),

          // 다음 버튼
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: canProceed ? onNext : null,
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
