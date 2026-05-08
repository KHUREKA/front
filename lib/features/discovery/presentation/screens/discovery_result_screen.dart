import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/domain/performance.dart';
import '../providers/discovery_filter_provider.dart';
import '../providers/discovery_result_provider.dart';
import '../widgets/filter_chip_row.dart';
import '../widgets/result_performance_card.dart';
import 'discovery_loading_screen.dart';

/// 발견 결과 화면.
///
/// - 로딩 중에는 [DiscoveryLoadingScreen] 노출 (1.5초 연출).
/// - 데이터 도착 후, 카드들이 아래에서 위로 + 페이드 인 (stagger 100ms).
/// - 0개일 때는 친절한 빈 상태.
/// - 상단: X(홈) + "추천 공연 N개" + 필터 chip 가로 스크롤.
class DiscoveryResultScreen extends ConsumerWidget {
  const DiscoveryResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(discoveryFilterProvider);
    final asyncResult = ref.watch(discoveryResultProvider(filter));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: asyncResult.when(
          loading: () => const DiscoveryLoadingScreen(),
          error: (e, _) => _ErrorView(
            onRetry: () => ref.invalidate(discoveryResultProvider(filter)),
          ),
          data: (list) => _ResultBody(
            list: list,
            chipLabels: filter.chipLabels,
            onTapChip: (i) {
              // 단순 처리: 어떤 chip 이든 플로우 처음으로 돌아가서 수정.
              context.go(RouteNames.discovery);
            },
            onClose: () => context.go(RouteNames.home),
            // 카드 본문 탭 → 홈 카드와 동일하게 공연 상세 화면.
            onTapPerformance: (p) =>
                context.push(RouteNames.eventDetailFor(p.id)),
            // "예매하기" 버튼은 좌석 흐름으로 바로.
            onBookPerformance: (p) =>
                context.push(RouteNames.seatFor(p.id)),
          ),
        ),
      ),
    );
  }

}

class _ResultBody extends StatelessWidget {
  const _ResultBody({
    required this.list,
    required this.chipLabels,
    required this.onTapChip,
    required this.onClose,
    required this.onTapPerformance,
    required this.onBookPerformance,
  });

  final List<Performance> list;
  final List<String> chipLabels;
  final ValueChanged<int> onTapChip;
  final VoidCallback onClose;
  final ValueChanged<Performance> onTapPerformance;
  final ValueChanged<Performance> onBookPerformance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 바: X + 타이틀
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 28,
                  color: AppColors.textPrimary,
                ),
                tooltip: '홈으로',
              ),
              Expanded(
                child: Text(
                  '추천 공연 ${list.length}개',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 필터 chip
        FilterChipRow(labels: chipLabels, onTapLabel: onTapChip),

        const SizedBox(height: 16),

        // 결과
        Expanded(
          child: list.isEmpty
              ? _EmptyState(onRetry: () => onTapChip(0))
              : AnimationLimiter(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) {
                      final p = list[i];
                      return AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 2000),
                        delay: const Duration(milliseconds: 250),
                        child: SlideAnimation(
                          verticalOffset: 40.0,
                          curve: Curves.easeOutCubic,
                          child: FadeInAnimation(
                            curve: Curves.easeOut,
                            child: ResultPerformanceCard(
                              performance: p,
                              onTap: () => onTapPerformance(p),
                              onBook: () => onBookPerformance(p),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😅', style: TextStyle(fontSize: 64, height: 1)),
            const SizedBox(height: 20),
            Text(
              '이런 공연이 없어요',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '조건을 좀 바꿔볼까요?',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.tune_rounded, size: 22),
                label: const Text('조건 다시 고르기'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  textStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😢', style: TextStyle(fontSize: 64, height: 1)),
            const SizedBox(height: 20),
            Text(
              '잠시 문제가 생겼어요',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '다시 시도해주세요',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 22),
                label: const Text('다시 시도'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  textStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
