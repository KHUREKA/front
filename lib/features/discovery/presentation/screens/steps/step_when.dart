import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/discovery_filter.dart';
import '../../providers/discovery_filter_provider.dart';
import '../../widgets/option_card.dart';
import '../../widgets/question_text.dart';

/// Q3. 언제쯤 보고 싶으세요?
///
/// - 5개 옵션, 단일 선택, 즉시 다음으로 진행
class StepWhen extends ConsumerWidget {
  const StepWhen({
    super.key,
    required this.onComplete,
  });

  /// Q3 까지 마쳤을 때 호출.
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(discoveryFilterProvider).when;
    final notifier = ref.read(discoveryFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const QuestionText(question: '언제쯤\n보고 싶으세요?'),
          const SizedBox(height: 32),

          for (final opt in DateRangeOption.values) ...[
            OptionCard(
              label: opt.displayLabel,
              emoji: opt.emoji,
              selected: selected == opt,
              onTap: () {
                notifier.setWhen(opt);
                // 단일 선택 즉시 진행 — 시각적 피드백 위해 약간 지연.
                Future.delayed(const Duration(milliseconds: 180), onComplete);
              },
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
