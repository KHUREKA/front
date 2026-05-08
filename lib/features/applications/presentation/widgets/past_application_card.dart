import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/lottery_application.dart';
import '../../domain/lottery_status.dart';

/// 지난 응모 카드 — 미당첨/취소/관람 완료 모두 표시.
class PastApplicationCard extends StatelessWidget {
  const PastApplicationCard({
    super.key,
    required this.application,
    this.onTap,
    this.onSimilar,
  });

  final LotteryApplication application;
  final VoidCallback? onTap;

  /// 미당첨일 때 "비슷한 공연 보기" 콜백.
  final VoidCallback? onSimilar;

  @override
  Widget build(BuildContext context) {
    final perf = application.performance;
    final appliedText =
        '${PerformanceDateFormat.compactSingleDay(application.appliedAt)} 응모';
    final showSimilar =
        application.status == LotteryStatus.lost && onSimilar != null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Opacity(
                  opacity: 0.7,
                  child: CachedNetworkImage(
                    imageUrl: perf.posterImageUrl,
                    width: 70,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 70,
                      height: 90,
                      color: const Color(0xFFEDEDED),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 70,
                      height: 90,
                      color: const Color(0xFFEDEDED),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StatusBadge(status: application.status),
                    const SizedBox(height: 6),
                    Text(
                      perf.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF555555),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appliedText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (showSimilar) ...[
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: onSimilar,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '👉 비슷한 공연 보기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              height: 1.2,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  AppColors.primary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final LotteryStatus status;

  ({Color bg, Color fg, String label}) get _colors {
    switch (status) {
      case LotteryStatus.lost:
        return (
          bg: const Color(0xFFEEEEEE),
          fg: const Color(0xFF555555),
          label: '⚪ 미당첨',
        );
      case LotteryStatus.cancelled:
        return (
          bg: const Color(0xFFEEEEEE),
          fg: const Color(0xFF555555),
          label: '↩ 취소함',
        );
      case LotteryStatus.completed:
        return (
          bg: const Color(0xFFE0F5EE),
          fg: const Color(0xFF006C5C),
          label: '✓ 관람 완료',
        );
      case LotteryStatus.pending:
      case LotteryStatus.won:
        // PastApplicationCard 에서 받지 않는 케이스. 안전 처리.
        return (
          bg: const Color(0xFFEEEEEE),
          fg: const Color(0xFF555555),
          label: status.displayLabel,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        c.label,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: c.fg,
          height: 1.2,
        ),
      ),
    );
  }
}
