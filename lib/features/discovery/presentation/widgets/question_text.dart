import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 발견 플로우 각 단계 상단의 질문/보조 설명 영역.
///
/// 어르신 친화: 질문은 displayLarge(32sp), 보조는 bodyLarge(18sp)로 큼직하게.
class QuestionText extends StatelessWidget {
  const QuestionText({
    super.key,
    required this.question,
    this.helper,
  });

  final String question;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: AppTextStyles.displayLarge),
        if (helper != null) ...[
          const SizedBox(height: 8),
          Text(
            helper!,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
