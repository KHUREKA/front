import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
/// - data: 자동으로 오른쪽→왼쪽 무한 루프 스크롤 (사용자 터치 중엔 일시정지)
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
          return _AutoScrollNearbyList(
            items: list,
            onTap: onTapPerformance,
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

/// 무한 가로 스크롤 — `ListView.builder(itemCount: null)` 로 인덱스를 무한 만들고
/// 모듈로로 [items] 를 순환. [Ticker] 가 매 프레임 일정 px 만큼 offset 증가.
///
/// 사용자가 화면을 누르고 있는 동안엔 [Listener] 로 감지해 일시정지.
class _AutoScrollNearbyList extends StatefulWidget {
  const _AutoScrollNearbyList({required this.items, this.onTap});

  final List<Performance> items;
  final void Function(Performance)? onTap;

  @override
  State<_AutoScrollNearbyList> createState() => _AutoScrollNearbyListState();
}

class _AutoScrollNearbyListState extends State<_AutoScrollNearbyList>
    with SingleTickerProviderStateMixin {
  static const double _pixelsPerSecond = 28.0; // 초당 28px — 부드럽고 안 바쁨
  static const double _cardWidth = 200; // NearbyPerformanceCard 의 폭(추정) + 간격

  final ScrollController _scrollCtrl = ScrollController();
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final dt = _lastElapsed == Duration.zero
        ? 0.0
        : (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;

    if (_userInteracting || !_scrollCtrl.hasClients) return;
    final delta = _pixelsPerSecond * dt;
    if (delta <= 0) return;

    final next = _scrollCtrl.offset + delta;
    // ListView.builder(itemCount:null) 이라 max 가 무한이지만, 안정성 위해 클램프.
    final max = _scrollCtrl.position.maxScrollExtent;
    if (max.isFinite && next > max) {
      // 비어있을 일은 없지만 안전망.
      _scrollCtrl.jumpTo(0);
    } else {
      _scrollCtrl.jumpTo(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    return Listener(
      onPointerDown: (_) => _userInteracting = true,
      onPointerUp: (_) => _userInteracting = false,
      onPointerCancel: (_) => _userInteracting = false,
      child: ListView.builder(
        controller: _scrollCtrl,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        // null = 무한 — 모듈로로 같은 목록을 끝없이 순환.
        itemCount: null,
        itemExtent: null,
        itemBuilder: (context, i) {
          final p = items[i % items.length];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: _cardWidth - 16, // 본 카드 자체 너비; 우측 패딩으로 간격 보정
              child: NearbyPerformanceCard(
                performance: p,
                onTap: widget.onTap == null ? null : () => widget.onTap!(p),
              ),
            ),
          );
        },
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
