import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 폼 단위 에러 메시지 박스.
///
/// 부드러운 빨강 배경 + 아이콘 + 한국어 메시지로 구성.
/// 입력 필드 단위 에러는 [AuthTextField] 의 errorText 로 처리하고,
/// 이 위젯은 "로그인 실패" 같은 폼 전체 결과 메시지에 사용.
class FriendlyErrorText extends StatelessWidget {
  const FriendlyErrorText({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.error, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 16,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
