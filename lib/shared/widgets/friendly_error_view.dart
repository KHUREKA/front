import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// 어르신 친화 에러 화면/뷰.
///
/// - 큰 이모지 + 한국어 문구로 원인을 부드럽게 전달
/// - "다시 시도" 버튼 (56dp 이상) 으로 회복 동작 유도
/// - [compact] = true 면 가로/세로 영역이 좁은 곳(가로 스크롤 슬롯 등)에서 사용
class FriendlyErrorView extends StatelessWidget {
  const FriendlyErrorView({
    super.key,
    this.emoji = '😅',
    this.title = '잠시 문제가 생겼어요',
    this.description = '다시 시도해주세요',
    this.onRetry,
    this.compact = false,
  });

  final String emoji;
  final String title;
  final String description;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final emojiSize = compact ? 40.0 : 64.0;
    final spacingTop = compact ? 12.0 : 20.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: emojiSize, height: 1)),
            SizedBox(height: spacingTop),
            Text(
              title,
              textAlign: TextAlign.center,
              style: compact
                  ? AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )
                  : AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: compact ? 16 : 24),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 22),
                  label: const Text('다시 시도'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    textStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
