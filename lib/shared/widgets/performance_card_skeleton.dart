import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';

/// 공용 shimmer 래퍼.
///
/// 모든 스켈레톤이 공유하는 톤으로, surface 위에서 자연스럽게 흐르도록
/// base/highlight 색을 잡았다.
class _PerformanceShimmer extends StatelessWidget {
  const _PerformanceShimmer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEDEDED),
      highlightColor: const Color(0xFFF7F7F7),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

/// "내 근처 문화" 카드(180×320)와 매칭되는 스켈레톤.
class NearbyPerformanceCardSkeleton extends StatelessWidget {
  const NearbyPerformanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _PerformanceShimmer(
      child: Container(
        width: 180,
        height: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // 포스터 영역
            Container(
              width: 180,
              height: 240,
              decoration: const BoxDecoration(
                color: Color(0xFFE6E6E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            // 정보 영역
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(width: 140, height: 14),
                  const SizedBox(height: 8),
                  _bar(width: 100, height: 12),
                  const SizedBox(height: 6),
                  _bar(width: 120, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// "이런 문화도 있어요" 카드(가로형, 120dp 높이)와 매칭되는 스켈레톤.
class RecommendedPerformanceCardSkeleton extends StatelessWidget {
  const RecommendedPerformanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _PerformanceShimmer(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _bar(width: 60, height: 12),
                    const SizedBox(height: 10),
                    _bar(width: double.infinity, height: 16),
                    const SizedBox(height: 6),
                    _bar(width: 200, height: 14),
                    const SizedBox(height: 10),
                    _bar(width: 140, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
