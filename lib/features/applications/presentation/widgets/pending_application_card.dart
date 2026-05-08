import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/lottery_application.dart';
import 'countdown_widget.dart';

/// 대기중 (pending) 응모 카드.
///
/// - 상단: 포스터 + 상태 배지 + 제목/장소/날짜
/// - 구분선
/// - 하단: "추첨 발표까지" + 큰 카운트다운
class PendingApplicationCard extends StatelessWidget {
  const PendingApplicationCard({
    super.key,
    required this.application,
    this.onTap,
  });

  final LotteryApplication application;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final perf = application.performance;
    final dateText = PerformanceDateFormat.span(perf.startDate, perf.endDate);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: perf.posterImageUrl,
                        width: 80,
                        height: 110,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 80,
                          height: 110,
                          color: const Color(0xFFEDEDED),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 80,
                          height: 110,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _StatusBadge(),
                          const SizedBox(height: 8),
                          Text(
                            perf.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${perf.venue} · $dateText',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, left: 4),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 24,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // 구분선
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFFF0F0F0),
              ),

              // 카운트다운
              Container(
                color: const Color(0xFFFFF5F5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '추첨 발표까지',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        CountdownWidget(targetTime: application.lotteryDate),
                      ],
                    ),
                  ],
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
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '🟡 추첨 대기중',
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6E5500),
          height: 1.2,
        ),
      ),
    );
  }
}
