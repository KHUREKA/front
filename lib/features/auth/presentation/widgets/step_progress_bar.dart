import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 회원가입 단계 표시 바.
///
/// 상단: 진행률 바 (애니메이션)
/// 하단: "2/6 단계" 텍스트
class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  /// 1-indexed 표시값. (예: 2번째 단계 → currentStep = 2)
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final clamped = currentStep.clamp(0, totalSteps);
    final progress = totalSteps == 0 ? 0.0 : clamped / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(color: AppColors.surface),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: constraints.maxWidth * progress,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$clamped / $totalSteps 단계',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
