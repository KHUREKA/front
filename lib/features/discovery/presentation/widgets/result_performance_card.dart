import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../home/domain/performance.dart';
import '../../../home/domain/performance_genre.dart';

/// 결과 화면의 큰 공연 카드.
///
/// - 화면폭 - 48dp × 280dp, 모서리 20px
/// - 포스터 풀블리드 + 하단 60% 검정 그라데이션
/// - 좌상단 장르 chip / 우상단 거리 chip
/// - 하단: 제목 22sp / 장소·날짜 16sp / 가격 14sp (모두 흰색)
/// - 우하단 "예매하기" 코랄 풀 버튼
class ResultPerformanceCard extends StatelessWidget {
  const ResultPerformanceCard({
    super.key,
    required this.performance,
    this.onTap,
    this.onBook,
  });

  final Performance performance;
  final VoidCallback? onTap;
  final VoidCallback? onBook;

  static const double height = 280;
  static const double radius = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. 포스터
              CachedNetworkImage(
                imageUrl: performance.posterImageUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 200),
                placeholder: (_, __) => Container(color: const Color(0xFF222222)),
                errorWidget: (_, __, ___) =>
                    Container(color: const Color(0xFF222222)),
              ),

              // 2. 하단 그라데이션 (60%)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xCC000000),
                      Color(0xE6000000),
                    ],
                    stops: [0.0, 0.4, 0.78, 1.0],
                  ),
                ),
              ),

              // 3. 좌상단 장르 chip
              Positioned(
                top: 16,
                left: 16,
                child: _GenreChip(genre: performance.genre),
              ),

              // 4. 우상단 거리 chip
              if (performance.distanceKm != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: _DistanceChip(km: performance.distanceKm!),
                ),

              // 5. 하단 정보 + 예매 버튼
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      performance.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _venueAndDate(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _priceText(),
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.80),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          textStyle: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('예매하기'),
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

  String _venueAndDate() {
    final date = PerformanceDateFormat.compactSingleDay(performance.startDate);
    return '${performance.venue} · $date';
  }

  String _priceText() {
    final f = NumberFormat('#,###');
    final min = f.format(performance.priceMin);
    final max = f.format(performance.priceMax);
    if (performance.priceMin == performance.priceMax) {
      return '$min원';
    }
    return '$min원 ~ $max원';
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.genre});
  final PerformanceGenre genre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: genre.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(genre.emoji, style: const TextStyle(fontSize: 14, height: 1)),
          const SizedBox(width: 4),
          Text(
            genre.displayName,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistanceChip extends StatelessWidget {
  const _DistanceChip({required this.km});
  final double km;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📍', style: TextStyle(fontSize: 12, height: 1)),
          const SizedBox(width: 4),
          Text(
            '${km.toStringAsFixed(1)}km',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
