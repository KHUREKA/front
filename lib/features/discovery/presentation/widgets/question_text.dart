import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'stagger_fade_slide.dart';

/// 발견 플로우 각 단계 상단의 질문/보조 설명 영역.
///
/// 어르신 친화: 질문은 displayLarge(32sp), 보조는 bodyLarge(18sp)로 큼직하게.
///
/// [animationController] 가 주어지면 [questionInterval] / [helperInterval]
/// 에 맞춰 단계적으로 등장한다. 없으면 정적 표시.
class QuestionText extends StatelessWidget {
  const QuestionText({
    super.key,
    required this.question,
    this.helper,
    this.animationController,
    this.questionInterval,
    this.helperInterval,
  });

  final String question;
  final String? helper;
  final AnimationController? animationController;
  final Interval? questionInterval;
  final Interval? helperInterval;

  @override
  Widget build(BuildContext context) {
    Widget questionWidget = Text(question, style: AppTextStyles.displayLarge);
    Widget? helperWidget;
    if (helper != null) {
      helperWidget = Text(
        helper!,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    if (animationController != null) {
      questionWidget = StaggerFadeSlide(
        controller: animationController!,
        interval: questionInterval ??
            const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
        child: questionWidget,
      );
      if (helperWidget != null) {
        helperWidget = StaggerFadeSlide(
          controller: animationController!,
          interval: helperInterval ??
              const Interval(0.20, 0.65, curve: Curves.easeOutCubic),
          child: helperWidget,
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionWidget,
        if (helperWidget != null) ...[
          const SizedBox(height: 8),
          helperWidget,
        ],
      ],
    );
  }
}
