import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// 발견 플로우의 큰 선택지 카드.
///
/// - 어르신 친화: 높이 72dp, 본문 18sp, 이모지 24sp
/// - 선택 상태: 코랄 보더 + 옅은 코랄 배경 + 우측 체크 아이콘
/// - 비선택: 회색 보더 + 흰 배경
/// - [fullWidth] = true 면 전체 폭 (Q1 의 "상관없어요" 같은 옵션)
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
    this.fullWidth = false,
  });

  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : AppColors.border;
    final bgColor = selected
        ? AppColors.primary.withValues(alpha: 0.08)
        : Colors.white;
    final textColor =
        selected ? AppColors.primary : AppColors.textPrimary;
    final textWeight = selected ? FontWeight.w700 : FontWeight.w600;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment:
                fullWidth ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24, height: 1)),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: textWeight,
                    color: textColor,
                    height: 1.3,
                  ),
                ),
              ),
              if (selected && !fullWidth) ...[
                const SizedBox(width: 8),
                const Spacer(),
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
