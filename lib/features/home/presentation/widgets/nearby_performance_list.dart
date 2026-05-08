import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../../shared/widgets/performance_card_skeleton.dart';
import '../../domain/performance.dart';
import '../providers/home_provider.dart';
import 'nearby_performance_card.dart';

/// "내 근처 문화" 가로 스크롤 리스트.
///
/// - 좌우 패딩 24, 카드 사이 간격 16
/// - loading: 스켈레톤 3개
/// - error: 친절한 메시지 + 다시 시도
/// - empty: 안내 텍스트
class NearbyPerformanceList extends ConsumerWidget {
  const NearbyPerformanceList({super.key, this.onTapPerformance});

  static const double height = 340;
  final void Function(Performance performance)? onTapPerformance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(nearbyPerformancesProvider);

    return SizedBox(
      height: height,
      child: asyncList.when(
        data: (list) {
          if (list.isEmpty) return const _EmptyState();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              final p = list[i];
              return NearbyPerformanceCard(
                performance: p,
                onTap: onTapPerformance == null ? null : () => onTapPerformance!(p),
              );
            },
          );
        },
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, __) => const NearbyPerformanceCardSkeleton(),
        ),
        error: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FriendlyErrorView(
            compact: true,
            title: '근처 공연을 불러오지 못했어요',
            description: '잠시 후 다시 시도해주세요',
            onRetry: () => ref.invalidate(nearbyPerformancesProvider),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 40, height: 1)),
            const SizedBox(height: 12),
            Text(
              '내 근처에 등록된 공연이 없어요',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
