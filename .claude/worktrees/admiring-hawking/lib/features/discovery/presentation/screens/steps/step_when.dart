import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/discovery_filter.dart';
import '../../providers/discovery_filter_provider.dart';
import '../../widgets/option_card.dart';
import '../../widgets/question_text.dart';
import '../../widgets/stagger_fade_slide.dart';

/// Q3. 언제쯤 보고 싶으세요?
///
/// - 5개 옵션, 단일 선택, 즉시 다음으로 진행
/// - [isActive] 가 true 가 되는 순간 cascade 애니메이션 재생
class StepWhen extends ConsumerStatefulWidget {
  const StepWhen({
    super.key,
    required this.onComplete,
    this.isActive = true,
  });

  /// Q3 까지 마쳤을 때 호출.
  final VoidCallback onComplete;
  final bool isActive;

  @override
  ConsumerState<StepWhen> createState() => _StepWhenState();
}

class _StepWhenState extends ConsumerState<StepWhen>
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
  void didUpdateWidget(StepWhen old) {
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

  /// 옵션 카드별 stagger interval. 카드 5개를 0.40~0.95 사이에 분배.
  Interval _intervalForOption(int index, int total) {
    const begin = 0.40;
    const end = 0.95;
    const itemSpan = 0.30;
    final maxStart = end - itemSpan;
    final step = total > 1 ? ((maxStart - begin) / (total - 1)) : 0.0;
    final s = begin + step * index;
    return Interval(s, s + itemSpan, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(discoveryFilterProvider).when;
    final notifier = ref.read(discoveryFilterProvider.notifier);
    final options = DateRangeOption.values;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          QuestionText(
            question: '언제쯤\n보고 싶으세요?',
            animationController: _ctrl,
          ),
          const SizedBox(height: 32),
          for (int i = 0; i < options.length; i++) ...[
            StaggerFadeSlide(
              controller: _ctrl,
              interval: _intervalForOption(i, options.length),
              child: OptionCard(
                label: options[i].displayLabel,
                emoji: options[i].emoji,
                selected: selected == options[i],
                onTap: () {
                  notifier.setWhen(options[i]);
                  // 단일 선택 즉시 진행 — 시각적 피드백 위해 약간 지연.
                  Future.delayed(
                      const Duration(milliseconds: 180), widget.onComplete);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
