import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/section.dart';
import 'seat_view_image.dart';

/// 한 구역의 무대 뷰 카드.
///
/// - 풀블리드 사진 + 하단 그라데이션 + 구역명/거리/가격
/// - [overlayBadge] 가 있으면 카드 상단에 코랄 글로우 안내 (예: "⬆ 1순위로 올리기")
/// - [scale], [verticalOffset] 으로 스택 뒤쪽 카드 미리 보이기 효과 가능
class SectionViewCard extends StatelessWidget {
  const SectionViewCard({
    super.key,
    required this.section,
    this.overlayBadge,
    this.elevation = 16,
  });

  final Section section;
  final String? overlayBadge;
  final double elevation;

  static const double radius = 24;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      elevation: elevation,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 무대 뷰 사진
          SeatViewImage(path: section.stageViewImageUrl),

          // 하단 그라데이션
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xCC000000),
                  Color(0xF2000000),
                ],
                stops: [0.0, 0.45, 0.78, 1.0],
              ),
            ),
          ),

          // 좌상단 등급 chip
          Positioned(
            top: 16,
            left: 16,
            child: _TierChip(tier: section.tier),
          ),

          // 정보 텍스트 (좌하단)
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  section.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  section.distanceLabel,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${NumberFormat('#,###').format(section.price)}원',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.95),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // 상단 글로우 배지
          if (overlayBadge != null)
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.55),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    overlayBadge!,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier});
  final SeatTier tier;

  Color get _color {
    switch (tier) {
      case SeatTier.vip:
        return const Color(0xFFE0484D);
      case SeatTier.r:
        return const Color(0xFFFF7A5F);
      case SeatTier.s:
        return const Color(0xFF6B7B8C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tier.displayName,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.2,
        ),
      ),
    );
  }
}
