import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/performance.dart';
import '../../domain/performance_genre.dart';

/// "이런 문화도 있어요" 섹션의 가로형 카드.
///
/// - 화면 폭 - 48dp (좌우 24 패딩) × 120dp
/// - 포스터 104×104 + 정보 영역 (장르 라벨 / 제목 / 날짜)
/// - 우측 끝 화살표
class RecommendedPerformanceCard extends StatelessWidget {
  const RecommendedPerformanceCard({
    super.key,
    required this.performance,
    this.onTap,
  });

  final Performance performance;
  final VoidCallback? onTap;

  static const double height = 120;
  static const double radius = 16;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  _Poster(url: performance.posterImageUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _Info(performance: performance),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 28,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 104,
        height: 104,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (_, __) => Container(
          width: 104,
          height: 104,
          color: const Color(0xFFEDEDED),
        ),
        errorWidget: (_, __, ___) => Container(
          width: 104,
          height: 104,
          color: const Color(0xFFEDEDED),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            size: 28,
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.performance});

  final Performance performance;

  @override
  Widget build(BuildContext context) {
    final dateText = PerformanceDateFormat.span(
      performance.startDate,
      performance.endDate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          performance.genre.displayName,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: performance.genre.color,
            height: 1.2,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          performance.title,
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
        const SizedBox(height: 4),
        Text(
          dateText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
