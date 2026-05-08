import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../map/presentation/widgets/map_inline_preview.dart';
import '../../domain/transport_info.dart';

/// 교통편 섹션.
///
/// - 지도 미리보기 (placeholder Container)
/// - 주소 + 복사 버튼
/// - 지하철/버스/택시 카드
/// - "지도 앱으로 길찾기" 버튼
class TransportSection extends StatelessWidget {
  const TransportSection({
    super.key,
    required this.info,
    this.onCopyAddress,
    this.onOpenMap,
    this.onOpenMapPreview,
    this.mapEventId,
  });

  final TransportInfo info;
  final VoidCallback? onCopyAddress;
  final VoidCallback? onOpenMap;
  // 지도 미리보기 탭 핸들러 — 백엔드 /map?id=eventId WebView 진입.
  final VoidCallback? onOpenMapPreview;
  // 백엔드 이벤트 id. 있으면 placeholder 자리에 실제 지도 인라인 임베드.
  final int? mapEventId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '공연장 가는 길',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // 지도 — eventId 가 있으면 실제 지도 인라인 임베드,
        //        없으면 placeholder (탭 시 안내).
        AspectRatio(
          aspectRatio: 16 / 10,
          child: mapEventId != null && mapEventId! > 0
              ? MapInlinePreview(
                  eventId: mapEventId!,
                  onTap: onOpenMapPreview,
                )
              : Material(
                  color: const Color(0xFFE8EFF5),
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onOpenMapPreview,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _MapGridPainter()),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '지도 미리보기',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF6B7B8C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        const SizedBox(height: 16),

        // 주소
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.place_outlined,
                  size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  info.address,
                  style: AppTextStyles.bodyLarge.copyWith(fontSize: 16),
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

        const SizedBox(height: 16),

        // Tmap 경로 요약 (있으면) — 없으면 기존 subway/bus/taxi 폴백.
        if (info.tmapRoute != null) ...[
          _TmapRouteSummary(route: info.tmapRoute!),
          const SizedBox(height: 12),
          _SegmentsTimeline(segments: info.tmapRoute!.segments),
          if (_hasAccessibility(info.tmapRoute!)) ...[
            const SizedBox(height: 12),
            _AccessibilityCard(route: info.tmapRoute!),
          ],
        ] else ...[
          if (info.subway != null) ...[
            _TransportRow(
              emoji: '🚇',
              title: '지하철',
              description: info.subway!.displayLabel,
            ),
            const SizedBox(height: 10),
          ],
          if (info.bus != null) ...[
            _TransportRow(
              emoji: '🚌',
              title: '버스',
              description: info.bus!.displayLabel,
            ),
            const SizedBox(height: 10),
          ],
          if (info.taxi != null)
            _TransportRow(
              emoji: '🚕',
              title: '택시',
              description:
                  '예상 요금 ${NumberFormat('#,###').format(info.taxi!.estimatedFareKrw)}원, 약 ${info.taxi!.estimatedMinutes}분',
            ),
        ],

        const SizedBox(height: 16),

        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: onOpenMap,
            icon: const Icon(Icons.directions_rounded, size: 22),
            label: const Text('지도 앱으로 길찾기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _TransportRow extends StatelessWidget {
  const _TransportRow({
    required this.emoji,
    required this.title,
    required this.description,
  });

  final String emoji;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22, height: 1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Tmap 경로 요약 (총시간/환승/도보/요금) + 한 줄 안내
// ─────────────────────────────────────────
bool _hasAccessibility(TmapTransitRouteSummary r) =>
    (r.nearestStation != null && r.nearestStation!.isNotEmpty) ||
    (r.recommendedExit != null && r.recommendedExit!.isNotEmpty) ||
    (r.caution != null && r.caution!.isNotEmpty);

class _TmapRouteSummary extends StatelessWidget {
  const _TmapRouteSummary({required this.route});
  final TmapTransitRouteSummary route;

  @override
  Widget build(BuildContext context) {
    final priceFmt = NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.access_time_rounded,
                    size: 20, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                '예상 소요 시간',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.92),
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '약 ${_formatMinutes(route.totalTimeMinutes)}',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          if ((route.summaryMessage ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              route.summaryMessage!,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.92),
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryChip(
                icon: Icons.swap_horiz_rounded,
                label: '환승 ${route.transferCount}회',
              ),
              if (route.paymentKrw > 0)
                _SummaryChip(
                  icon: Icons.payments_outlined,
                  label: '${priceFmt.format(route.paymentKrw)}원',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `126` → `2시간 6분`, `60` → `1시간`, `45` → `45분`.
String _formatMinutes(int total) {
  if (total < 60) return '$total분';
  final h = total ~/ 60;
  final m = total % 60;
  if (m == 0) return '$h시간';
  return '$h시간 $m분';
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// 구간 타임라인 — 버스/지하철/도보 단계별 카드 (staggered fade-slide)
// ─────────────────────────────────────────
class _SegmentsTimeline extends StatefulWidget {
  const _SegmentsTimeline({required this.segments});
  final List<TransitSegment> segments;

  @override
  State<_SegmentsTimeline> createState() => _SegmentsTimelineState();
}

class _SegmentsTimelineState extends State<_SegmentsTimeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // 한 카드가 등장하는 데 걸리는 비율(0..1) + 카드 사이 시간차 비율.
  static const _itemSpan = 0.55; // 각 항목이 0..1 중 차지하는 비율
  static const _stagger = 0.16; // 카드 간 시작 시간 차이

  @override
  void initState() {
    super.initState();
    final n = widget.segments.length;
    // 마지막 카드까지 충분히 들어갈 길이.
    final ms = 350 + (n.clamp(1, 6) - 1) * 130;
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// `index` 번째 카드가 사용할 [Interval] 계산.
  Interval _intervalFor(int index, int total) {
    if (total <= 1) return const Interval(0.0, 1.0);
    final maxStart = (1.0 - _itemSpan).clamp(0.0, 1.0);
    final step = (total > 1)
        ? (maxStart / (total - 1)).clamp(0.0, _stagger)
        : 0.0;
    final begin = (index * step).clamp(0.0, maxStart);
    final end = (begin + _itemSpan).clamp(0.0, 1.0);
    return Interval(begin, end, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final segments = widget.segments;
    if (segments.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < segments.length; i++) ...[
          _StaggeredItem(
            controller: _ctrl,
            interval: _intervalFor(i, segments.length),
            child: _SegmentRow(segment: segments[i]),
          ),
          if (i < segments.length - 1)
            _StaggeredItem(
              controller: _ctrl,
              interval: _intervalFor(i, segments.length),
              child: const _SegmentConnector(),
            ),
        ],
      ],
    );
  }
}

/// fade + 살짝 위로 슬라이드 — 자식 카드/커넥터에 공통 적용.
class _StaggeredItem extends StatelessWidget {
  const _StaggeredItem({
    required this.controller,
    required this.interval,
    required this.child,
  });
  final AnimationController controller;
  final Interval interval;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: controller, curve: interval);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class _SegmentRow extends StatelessWidget {
  const _SegmentRow({required this.segment});
  final TransitSegment segment;

  @override
  Widget build(BuildContext context) {
    final color = _parseHex(segment.colorHex) ?? AppColors.textSecondary;
    final emoji = _emojiFor(segment.mode);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 모드 컬러 인디케이터
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 20, height: 1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.displayName ?? segment.mode,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                if (segment.startName != null && segment.endName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${segment.startName} → ${segment.endName}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 우측: 시간 칩 (코랄 톤 + 시계 아이콘)
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 13, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  '${segment.minutes}분',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _emojiFor(String mode) {
    switch (mode) {
      case '버스':
        return '🚌';
      case '지하철':
        return '🚇';
      case '도보':
        return '🚶';
      default:
        return '🧭';
    }
  }

  Color? _parseHex(String? hex) {
    if (hex == null) return null;
    var h = hex.replaceFirst('#', '');
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    return v == null ? null : Color(v);
  }
}

class _SegmentConnector extends StatelessWidget {
  const _SegmentConnector();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 24),
          Icon(Icons.more_vert_rounded,
              size: 18, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// 접근성 가이드 — 가까운 역/추천 출구/주의사항
// ─────────────────────────────────────────
class _AccessibilityCard extends StatelessWidget {
  const _AccessibilityCard({required this.route});
  final TmapTransitRouteSummary route;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 18, height: 1)),
              const SizedBox(width: 8),
              Text(
                '도착 안내',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (route.nearestStation != null && route.nearestStation!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '가장 가까운 역: ${route.nearestStation}'
                '${route.recommendedExit != null && route.recommendedExit!.isNotEmpty ? " · ${route.recommendedExit}번 출구" : ""}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          if (route.caution != null && route.caution!.isNotEmpty)
            Text(
              route.caution!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD3DDE6)
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
