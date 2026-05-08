import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/maps/kakao_map_links.dart';
import '../../../../core/maps/tmap_route_service.dart';
import '../../../../core/maps/tmap_transit_route_dto.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../map/presentation/widgets/map_inline_preview.dart';
import '../../domain/performance.dart';
import '../../domain/performance_genre.dart';
import '../providers/home_provider.dart';

/// 공연 상세 화면.
///
/// 진입 경로: 홈/검색 카드 탭 → `/event/:eventId`.
/// - 상단: 포스터를 배경으로 한 collapsing AppBar
/// - 본문: 장르 칩 / 제목 / 일시 / 장소 / 가격 / 설명 / 지도 / 교통편
/// - 하단 고정: "응모하기" → `/seat/:id/mode`
class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.performanceId});

  final String performanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPerf = ref.watch(performanceByIdProvider(performanceId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: asyncPerf.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => FriendlyErrorView(
          title: '공연 정보를 불러오지 못했어요',
          description: '잠시 후 다시 시도해주세요',
          onRetry: () =>
              ref.invalidate(performanceByIdProvider(performanceId)),
        ),
        data: (perf) => _DetailContent(performance: perf),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.performance});
  final Performance performance;

  Future<void> _copyAddress(BuildContext context) async {
    final addr = performance.venueAddress;
    if (addr == null || addr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아직 주소 정보가 없어요.')),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: addr));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('주소를 복사했어요.')),
    );
  }

  Future<void> _openKakaoMap(BuildContext context) async {
    final links = KakaoMapLinks.build(
      destinationName: performance.venue,
      destinationLat: performance.destinationLatitude,
      destinationLng: performance.destinationLongitude,
    );
    if (links == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 정보가 부족해요.')),
      );
      return;
    }
    final uri = Uri.parse(links.mapUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지도 앱을 열 수 없어요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventId = int.tryParse(performance.id);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _PosterAppBar(performance: performance),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: _Header(performance: performance),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: _InfoRows(performance: performance),
              ),
            ),
            if ((performance.description ?? '').isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: _DescriptionSection(
                    description: performance.description!,
                  ),
                ),
              ),
            // 지도
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: _MapSection(
                  performance: performance,
                  eventId: eventId,
                  onCopyAddress: () => _copyAddress(context),
                  onOpenMap: () => _openKakaoMap(context),
                ),
              ),
            ),
            // 교통편 (Tmap)
            if (eventId != null && eventId > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: _TransitSection(eventId: eventId),
                ),
              ),
            // 하단 응모 버튼 자리 확보.
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),

        // 하단 고정 CTA
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _ApplyBar(
            onApply: () =>
                context.push(RouteNames.seatFor(performance.id)),
          ),
        ),

        // 좌상단 뒤로가기 (AppBar 기능을 SliverAppBar에 위임하는 대신 여기서)
        // → SliverAppBar leading 으로 처리하므로 불필요.
      ],
    );
  }
}

// ─────────────────────────────────────────
// 포스터 + 그라데이션 collapsing AppBar
// ─────────────────────────────────────────
class _PosterAppBar extends StatelessWidget {
  const _PosterAppBar({required this.performance});
  final Performance performance;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      leading: const _CircleBackButton(),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (performance.posterImageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: performance.posterImageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: const Color(0xFFEDEDED)),
                errorWidget: (_, __, ___) =>
                    Container(color: const Color(0xFFEDEDED)),
              )
            else
              Container(color: const Color(0xFFEDEDED)),
            // 위쪽 살짝 어둡게 — 뒤로가기 아이콘 가독성 확보
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Color(0x55000000), Colors.transparent],
                ),
              ),
            ),
            // 하단 white 페이드 — 제목으로 자연스럽게 이어지게
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.white, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white.withValues(alpha: 0.95),
        shape: const CircleBorder(),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          tooltip: '뒤로',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.home);
            }
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 헤더 — 장르 칩 / 제목 / 부제
// ─────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header({required this.performance});
  final Performance performance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: performance.genre.softColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(performance.genre.emoji,
                  style: const TextStyle(fontSize: 14, height: 1)),
              const SizedBox(width: 6),
              Text(
                performance.genre.displayName,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: performance.genre.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          performance.title,
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 26,
            height: 1.3,
          ),
        ),
        if ((performance.subtitle ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            performance.subtitle!,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────
// 정보 행 — 일시 / 장소 / 가격 / (옵션) 거리
// ─────────────────────────────────────────
class _InfoRows extends StatelessWidget {
  const _InfoRows({required this.performance});
  final Performance performance;

  @override
  Widget build(BuildContext context) {
    final priceFmt = NumberFormat('#,###');
    final dateText = performance.isSingleDay
        ? PerformanceDateFormat.singleDay(performance.startDate)
        : '${PerformanceDateFormat.compactSingleDay(performance.startDate)} ~ '
            '${PerformanceDateFormat.compactSingleDay(performance.endDate)}';

    String priceText;
    if (performance.priceMin <= 0 && performance.priceMax <= 0) {
      priceText = '가격 정보 준비중';
    } else if (performance.priceMin == performance.priceMax ||
        performance.priceMax <= 0) {
      priceText = '${priceFmt.format(performance.priceMin)}원';
    } else {
      priceText =
          '${priceFmt.format(performance.priceMin)}원 ~ ${priceFmt.format(performance.priceMax)}원';
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: '일시',
            value: dateText,
          ),
          const _DividerLine(),
          _InfoRow(
            icon: Icons.place_outlined,
            label: '장소',
            value: performance.venue,
            sub: performance.venueAddress,
          ),
          const _DividerLine(),
          _InfoRow(
            icon: Icons.payments_outlined,
            label: '가격',
            value: priceText,
          ),
          if (performance.distanceKm != null) ...[
            const _DividerLine(),
            _InfoRow(
              icon: Icons.near_me_rounded,
              label: '거리',
              value: '약 ${performance.distanceKm!.toStringAsFixed(1)}km',
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.sub,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((sub ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE9E9E9),
    );
  }
}

// ─────────────────────────────────────────
// 설명 섹션
// ─────────────────────────────────────────
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '공연 소개',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// 지도 섹션 — 인라인 미리보기 + 주소 + 카카오맵
// ─────────────────────────────────────────
class _MapSection extends StatelessWidget {
  const _MapSection({
    required this.performance,
    required this.eventId,
    required this.onCopyAddress,
    required this.onOpenMap,
  });

  final Performance performance;
  final int? eventId;
  final VoidCallback onCopyAddress;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '공연장 가는 길',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: eventId != null && eventId! > 0
              ? MapInlinePreview(
                  eventId: eventId!,
                  onTap: () =>
                      context.push(RouteNames.mapFor(eventId!)),
                )
              : _MapPlaceholder(),
        ),
        if ((performance.venueAddress ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.place_outlined,
                    size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    performance.venueAddress!,
                    style: AppTextStyles.bodyLarge.copyWith(fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: onCopyAddress,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('복사'),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: onOpenMap,
            icon: const Icon(Icons.directions_rounded, size: 20),
            label: const Text('카카오맵으로 길찾기'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.4),
              textStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFF5),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        '지도 정보를 준비하고 있어요',
        style: AppTextStyles.bodyMedium.copyWith(
          color: const Color(0xFF6B7B8C),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Tmap 대중교통 요약 섹션
// ─────────────────────────────────────────
class _TransitSection extends ConsumerStatefulWidget {
  const _TransitSection({required this.eventId});
  final int eventId;

  @override
  ConsumerState<_TransitSection> createState() => _TransitSectionState();
}

class _TransitSectionState extends ConsumerState<_TransitSection> {
  late Future<TmapTransitRouteDto> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<TmapTransitRouteDto> _fetch() async {
    // 백엔드가 userLat/userLng 를 필수로 요구하므로 위치를 먼저 받는다.
    // 실패하면 throw — FutureBuilder 가 그냥 섹션을 숨김.
    final loc = await ref.read(locationServiceProvider).getCurrentLocation();
    if (loc == null) {
      throw Exception('no_location');
    }
    return ref.read(tmapRouteServiceProvider).getRoute(
          eventId: widget.eventId,
          userLat: loc.latitude,
          userLng: loc.longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TmapTransitRouteDto>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return _LoadingTransit();
        }
        if (snap.hasError || snap.data == null) {
          return const SizedBox.shrink(); // 조용히 숨김
        }
        return _TransitSummaryCard(route: snap.data!);
      },
    );
  }
}

class _LoadingTransit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '교통편을 찾고 있어요',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransitSummaryCard extends StatelessWidget {
  const _TransitSummaryCard({required this.route});
  final TmapTransitRouteDto route;

  @override
  Widget build(BuildContext context) {
    final priceFmt = NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '대중교통으로 가는 길',
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '약 ${route.totalTime}분',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '소요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if ((route.summaryMessage ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              route.summaryMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(label: '환승 ${route.transferCount}회'),
              _Chip(label: '도보 ${route.totalWalk}m'),
              if (route.payment > 0)
                _Chip(label: '${priceFmt.format(route.payment)}원'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 하단 고정 응모 버튼
// ─────────────────────────────────────────
class _ApplyBar extends StatelessWidget {
  const _ApplyBar({required this.onApply});
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              textStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text('응모하기'),
          ),
        ),
      ),
    );
  }
}
