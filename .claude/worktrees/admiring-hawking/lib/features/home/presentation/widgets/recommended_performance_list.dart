import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../../shared/widgets/performance_card_skeleton.dart';
import '../../domain/performance.dart';
import '../providers/home_provider.dart';
import 'recommended_performance_card.dart';

/// "이런 문화도 있어요" — Sliver 로 반환하는 추천 카드 리스트.
///
/// HomeScreen 의 CustomScrollView 안에 그대로 꽂아 쓸 수 있다.
/// - 좌우 패딩 24, 카드 사이 간격 12
/// - loading: 스켈레톤 3개
/// - error: 친절한 메시지 + 다시 시도
/// - empty: 안내 텍스트
class RecommendedPerformanceSliverList extends ConsumerWidget {
  const RecommendedPerformanceSliverList({
    super.key,
    this.onTapPerformance,
  });

  final void Function(Performance performance)? onTapPerformance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(recommendedPerformancesProvider);

    return asyncList.when(
      data: (list) {
        if (list.isEmpty) {
          return const SliverToBoxAdapter(child: _EmptyState());
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = list[i];
              return RecommendedPerformanceCard(
                performance: p,
                onTap: onTapPerformance == null
                    ? null
                    : () => onTapPerformance!(p),
              );
            },
          ),
        );
      },
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList.separated(
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const RecommendedPerformanceCardSkeleton(),
        ),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: FriendlyErrorView(
            compact: true,
            title: '추천 공연을 불러오지 못했어요',
            description: '잠시 후 다시 시도해주세요',
            onRetry: () => ref.invalidate(recommendedPerformancesProvider),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: Column(
          children: [
            const Text('🎈', style: TextStyle(fontSize: 40, height: 1)),
            const SizedBox(height: 12),
            Text(
              '아직 추천할 공연이 없어요',
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
