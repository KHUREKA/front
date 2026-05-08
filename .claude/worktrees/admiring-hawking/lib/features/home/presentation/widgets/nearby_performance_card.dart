import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/performance.dart';

/// "내 근처 문화" 가로 스크롤에 들어가는 세로형 카드.
///
/// - 180 × 320dp, 모서리 20px
/// - 상단 포스터 (180×240, 위쪽만 라운드) + 거리 chip
/// - 하단 정보(180×80): 제목 / 장소 / 날짜
/// - 탭 시 [onTap] 호출 (라우팅은 부모 책임)
class NearbyPerformanceCard extends StatelessWidget {
  const NearbyPerformanceCard({
    super.key,
    required this.performance,
    this.onTap,
  });

  final Performance performance;
  final VoidCallback? onTap;

  static const double width = 180;
  static const double height = 340;
  static const double posterHeight = 240;
  static const double radius = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Poster(
                  url: performance.posterImageUrl,
                  distanceKm: performance.distanceKm,
                ),
                Expanded(child: _Info(performance: performance)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.url, required this.distanceKm});

  final String url;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: NearbyPerformanceCard.width,
      height: NearbyPerformanceCard.posterHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(NearbyPerformanceCard.radius),
              topRight: Radius.circular(NearbyPerformanceCard.radius),
            ),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: (_, __) => Container(color: const Color(0xFFEDEDED)),
              errorWidget: (_, __, ___) => Container(
                color: const Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  size: 32,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
          if (distanceKm != null)
            Positioned(
              top: 12,
              right: 12,
              child: _DistanceChip(distanceKm: distanceKm!),
            ),
        ],
      ),
    );
  }
}

/// 우상단 거리 칩 — "📍 2.3km".
class _DistanceChip extends StatelessWidget {
  const _DistanceChip({required this.distanceKm});

  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📍', style: TextStyle(fontSize: 12, height: 1)),
          const SizedBox(width: 4),
          Text(
            '${distanceKm.toStringAsFixed(1)}km',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
            Text(
              performance.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            _MetaRow(emoji: '🏛', text: performance.venue),
            const SizedBox(height: 4),
            _MetaRow(emoji: '📅', text: dateText),
          ],
        ),
      );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.emoji, required this.text});

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 12, height: 1)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
