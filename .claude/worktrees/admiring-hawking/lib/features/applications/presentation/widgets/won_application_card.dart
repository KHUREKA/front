import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/lottery_application.dart';

/// 당첨 (won) 응모 카드 — 가장 화려하게.
///
/// - 상단 코랄 그라데이션 배너 ("🎉 당첨되었어요!" + D-day)
/// - 본문: 포스터 + 제목/장소/일시
/// - 좌석 정보 박스
/// - 하단 버튼 2개: 티켓 보기 / 길찾기
class WonApplicationCard extends StatelessWidget {
  const WonApplicationCard({
    super.key,
    required this.application,
    this.onTicket,
    this.onDirections,
    this.onTap,
  });

  final LotteryApplication application;
  final VoidCallback? onTicket;
  final VoidCallback? onDirections;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final perf = application.performance;
    final seats = application.assignedSeats;
    final firstSeat = application.firstSeat;
    final daysUntil = application.timeUntilPerformance.inDays;
    final dateText = PerformanceDateFormat.singleDay(perf.startDate);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shadowColor: AppColors.primary.withValues(alpha: 0.25),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 축하 배너
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '🎉 당첨되었어요!',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Text(
                      daysUntil >= 0
                          ? '공연까지 D-${daysUntil == 0 ? 'day' : daysUntil}'
                          : '공연 진행중',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // 본문
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
                            perf.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateText,
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 좌석 정보
              if (firstSeat != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seats.length > 1
                            ? '내 좌석 (${seats.length}매)'
                            : '내 좌석',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        seats.length > 1
                            ? '${firstSeat.section}  ${seats.map((s) => '${s.row} ${s.seatNumber}').join(', ')}'
                            : firstSeat.fullLabel,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      if (daysUntil >= 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          daysUntil == 0
                              ? '오늘이 공연 날이에요! 🎊'
                              : '공연까지 ${daysUntil}일 남았어요!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              // 버튼들
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: onTicket,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: const Text('티켓 보기'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: onDirections,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('길찾기'),
                        ),
                      ),
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
