import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../providers/discovery_filter_provider.dart';
import '../../widgets/question_text.dart';
import '../../widgets/stagger_fade_slide.dart';

/// Q2. 찾으시는 가수나 공연이 있나요? (선택)
///
/// - 큰 입력창 (64dp 높이, 폰트 20sp) + 마이크 아이콘 (음성 입력 placeholder)
/// - 하단: [건너뛰기] 텍스트 버튼 | [다음] 코랄 버튼
/// - [isActive] 가 true 가 되는 순간 cascade 애니메이션 재생
class StepKeyword extends ConsumerStatefulWidget {
  const StepKeyword({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isActive = true,
  });

  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isActive;

  @override
  ConsumerState<StepKeyword> createState() => _StepKeywordState();
}

class _StepKeywordState extends ConsumerState<StepKeyword>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(discoveryFilterProvider).keyword ?? '';
    _controller = TextEditingController(text: initial);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.isActive) _ctrl.forward();
  }

  @override
  void didUpdateWidget(StepKeyword old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _ctrl.forward(from: 0);
    } else if (!widget.isActive && old.isActive) {
      _ctrl.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  void _commitAndNext() {
    ref.read(discoveryFilterProvider.notifier).setKeyword(_controller.text);
    widget.onNext();
  }

  void _skip() {
    ref.read(discoveryFilterProvider.notifier).setKeyword(null);
    widget.onSkip();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          QuestionText(
            question: '찾으시는 가수나\n공연이 있나요?',
            helper: '예: 임영웅, 락페스티벌, 시카고 등',
            animationController: _ctrl,
          ),
          const SizedBox(height: 32),

          // 입력창 (64dp, 폰트 20sp)
          StaggerFadeSlide(
            controller: _ctrl,
            interval: const Interval(0.40, 0.85, curve: Curves.easeOutCubic),
            child: SizedBox(
              height: 64,
              child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _commitAndNext(),
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: '입력해주세요 (선택)',
                hintStyle: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                  height: 1.4,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('음성 입력은 준비 중이에요.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.mic_rounded,
                    size: 28,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // 하단: 건너뛰기 + 다음
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      textStyle: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('건너뛰기'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _commitAndNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
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
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
