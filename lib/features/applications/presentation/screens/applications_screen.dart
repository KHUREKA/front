import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../../shared/widgets/main_bottom_navigation.dart';
import '../../domain/lottery_application.dart';
import '../../domain/lottery_status.dart';
import '../providers/applications_provider.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/past_application_card.dart';
import '../widgets/pending_application_card.dart';
import '../widgets/stats_chip.dart';
import '../widgets/won_application_card.dart';

/// 응모내역 메인 화면.
///
/// 하단 [MainBottomNavigation] "응모내역" (MainTab.lottery) 탭에 연결.
/// - 상단: "응모 내역" 타이틀 + StatsChip
/// - TabBar: 대기중 (N) / 당첨 (N) / 지난 응모 (N)
/// - 각 탭: pull-to-refresh + AsyncValue 분기 + EmptyState
class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() =>
      _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncStats = ref.watch(userStatsProvider);
    final asyncPending = ref.watch(pendingApplicationsProvider);
    final asyncWon = ref.watch(wonApplicationsProvider);
    final asyncPast = ref.watch(pastApplicationsProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '응모 내역',
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 26,
                    ),
                  ),
                ),
                asyncStats.maybeWhen(
                  data: (s) => StatsChip(
                    totalApplications: s.totalApplications,
                    totalWins: s.totalWins,
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // 탭바
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE)),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: '대기중 ${_count(asyncPending)}'),
                Tab(text: '당첨 ${_count(asyncWon)}'),
                Tab(text: '지난 응모 ${_count(asyncPast)}'),
              ],
            ),
          ),

          // 탭 콘텐츠
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PendingTab(asyncList: asyncPending),
                _WonTab(asyncList: asyncWon),
                _PastTab(asyncList: asyncPast),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _count(AsyncValue<List<LotteryApplication>> async) =>
      async.maybeWhen(
        data: (l) => '(${l.length})',
        orElse: () => '',
      );
}

// ─────────────────────────────────────
// 탭별 위젯 (KeepAlive로 스크롤 위치 보존)
// ─────────────────────────────────────

abstract class _TabWithKeepAlive extends ConsumerStatefulWidget {
  const _TabWithKeepAlive({super.key});
}

class _PendingTab extends ConsumerStatefulWidget {
  const _PendingTab({required this.asyncList});
  final AsyncValue<List<LotteryApplication>> asyncList;

  @override
  ConsumerState<_PendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends ConsumerState<_PendingTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.asyncList.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, __) => FriendlyErrorView(
        title: '응모 내역을 불러오지 못했어요',
        description: '잠시 후 다시 시도해주세요',
        onRetry: () => ref.invalidate(pendingApplicationsProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return EmptyStateView(
            emoji: '🎫',
            title: '응모한 공연이 없어요',
            description: '마음에 드는 공연을 응모해보세요!',
            actionLabel: '공연 둘러보기',
            onAction: () => context.go(RouteNames.home),
            animation: EmptyAnimation.bob,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(pendingApplicationsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) {
              final app = list[i];
              return PendingApplicationCard(
                application: app,
                onTap: () =>
                    context.push(RouteNames.applicationDetailFor(app.id)),
              );
            },
          ),
        );
      },
    );
  }
}

class _WonTab extends ConsumerStatefulWidget {
  const _WonTab({required this.asyncList});
  final AsyncValue<List<LotteryApplication>> asyncList;

  @override
  ConsumerState<_WonTab> createState() => _WonTabState();
}

class _WonTabState extends ConsumerState<_WonTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.asyncList.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, __) => FriendlyErrorView(
        title: '응모 내역을 불러오지 못했어요',
        description: '잠시 후 다시 시도해주세요',
        onRetry: () => ref.invalidate(wonApplicationsProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const EmptyStateView(
            emoji: '🍀',
            title: '아직 당첨된 공연이 없어요',
            description: '곧 좋은 소식이 있을 거예요!',
            animation: EmptyAnimation.sway,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(wonApplicationsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) {
              final app = list[i];
              return WonApplicationCard(
                application: app,
                onTap: () =>
                    context.push(RouteNames.applicationTicketFor(app.id)),
                onTicket: () =>
                    context.push(RouteNames.applicationTicketFor(app.id)),
                onDirections: () {
                  context.push(RouteNames.applicationTicketFor(app.id));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _PastTab extends ConsumerStatefulWidget {
  const _PastTab({required this.asyncList});
  final AsyncValue<List<LotteryApplication>> asyncList;

  @override
  ConsumerState<_PastTab> createState() => _PastTabState();
}

class _PastTabState extends ConsumerState<_PastTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.asyncList.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, __) => FriendlyErrorView(
        title: '응모 내역을 불러오지 못했어요',
        description: '잠시 후 다시 시도해주세요',
        onRetry: () => ref.invalidate(pastApplicationsProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const EmptyStateView(
            emoji: '📭',
            title: '지난 응모 내역이 없어요',
            animation: EmptyAnimation.wiggle,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(pastApplicationsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final app = list[i];
              return PastApplicationCard(
                application: app,
                onTap: () =>
                    context.push(RouteNames.applicationDetailFor(app.id)),
                onSimilar: app.status == LotteryStatus.lost
                    ? () => context.go(RouteNames.discovery)
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}
