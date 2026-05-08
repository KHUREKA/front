import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/assigned_seat.dart';
import '../../domain/lottery_application.dart';
import '../../domain/transport_info.dart';
import '../providers/applications_provider.dart';
import '../widgets/transport_section.dart';

/// 당첨 티켓 + 교통편 풀화면.
///
/// 구성:
/// - 상단 코랄 그라데이션 축하 헤더
/// - 티켓 카드 (포스터 + 좌석 정보 + 좌석 뷰 + QR placeholder)
/// - 캘린더 추가 버튼
/// - 교통편 섹션
/// - 가족에게 알리기
class WonTicketScreen extends ConsumerWidget {
  const WonTicketScreen({
    super.key,
    required this.applicationId,
  });

  final String applicationId;

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  String _formatDateTime(DateTime dt) {
    final wd = _weekdays[dt.weekday - 1];
    final hour = dt.hour;
    final ampm = hour < 12 ? '오전' : '오후';
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${dt.year}년 ${dt.month}월 ${dt.day}일 ($wd) $ampm $h12시';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncApp = ref.watch(applicationDetailProvider(applicationId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: asyncApp.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => FriendlyErrorView(
          title: '티켓을 불러오지 못했어요',
          description: '잠시 후 다시 시도해주세요',
          onRetry: () =>
              ref.invalidate(applicationDetailProvider(applicationId)),
        ),
        data: (app) {
          final asyncTransport =
              ref.watch(transportInfoProvider(app.performance.id));
          return CustomScrollView(
            slivers: [
              // 헤더와 카드를 한 sliver 안 Stack 으로 묶어 paint 순서 + clip 회피.
              // 카드는 헤더 바닥에서 28px 위로 올라와 살짝 겹친다.
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    children: [
                      _CelebrationHeader(
                        onClose: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(RouteNames.lottery);
                          }
                        },
                      ),
                      // header height(240) - overlap(28) = 212
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 212, 20, 0),
                        child: _TicketCard(
                          application: app,
                          formatDateTime: _formatDateTime,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('캘린더 추가는 준비 중이에요.')),
                        );
                      },
                      icon: const Icon(Icons.calendar_month_rounded, size: 22),
                      label: const Text('캘린더에 추가하기'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                        textStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: asyncTransport.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: FriendlyErrorView(
                        compact: true,
                        title: '교통편 정보를 불러오지 못했어요',
                        description: '잠시 후 다시 시도해주세요',
                        onRetry: () => ref.invalidate(
                            transportInfoProvider(app.performance.id)),
                      ),
                    ),
                    data: (info) => TransportSection(
                      info: info,
                      mapEventId: app.eventId,
                      onCopyAddress: () => _copyAddress(context, info),
                      onOpenMap: () => _openKakaoMap(context, info),
                      onOpenMapPreview: () =>
                          _openMapPreview(context, app.eventId),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('가족 공유는 준비 중이에요.')),
                        );
                      },
                      icon:
                          const Icon(Icons.family_restroom_rounded, size: 22),
                      label: const Text('가족에게 알리기'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(
                            color: AppColors.border, width: 1.5),
                        textStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────
// 교통편 액션 핸들러
// ─────────────────────────────────────
void _openMapPreview(BuildContext context, int? eventId) {
  if (eventId == null || eventId <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('지도 정보가 곧 추가될 거예요.')),
    );
    return;
  }
  // 웹/네이티브 모두 풀스크린 진입.
  // - Native: 인앱 WebView
  // - Web: iframe + 하단 "새 탭에서 열기" 폴백 버튼
  context.push(RouteNames.mapFor(eventId));
}

Future<void> _copyAddress(BuildContext context, TransportInfo info) async {
  if (info.address.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('아직 주소 정보가 없어요.')),
    );
    return;
  }
  await Clipboard.setData(ClipboardData(text: info.address));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('주소를 복사했어요.'),
      duration: Duration(seconds: 2),
    ),
  );
}

Future<void> _openKakaoMap(BuildContext context, TransportInfo info) async {
  final url = info.kakaoMapUrl;
  if (url == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('지도 정보가 아직 준비되지 않았어요.')),
    );
    return;
  }
  final uri = Uri.parse(url);
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('지도 앱을 열 수 없어요. 브라우저로 열게요.')),
    );
    await launchUrl(uri); // 폴백: 인앱 브라우저
  }
}

// ─────────────────────────────────────
// 상단 축하 헤더 (애니메이션)
// ─────────────────────────────────────
class _CelebrationHeader extends ConsumerStatefulWidget {
  const _CelebrationHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  ConsumerState<_CelebrationHeader> createState() =>
      _CelebrationHeaderState();
}

class _CelebrationHeaderState extends ConsumerState<_CelebrationHeader>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _drift;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final greeting =
        user != null ? '축하드려요, ${user.name}님' : '축하드려요!';

    return Container(
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF7B81), AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 떠다니는 sparkle 들 (배경 레이어)
            AnimatedBuilder(
              animation: _drift,
              builder: (_, __) =>
                  _SparkleLayer(progress: _drift.value),
            ),

            // 좌상단 닫기
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close_rounded,
                    size: 28, color: Colors.white),
              ),
            ),

            // 중앙 콘텐츠
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // 🎊 — elasticOut 으로 통통 등장 + 위아래 부드러운 떠오름
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _entrance,
                        curve: const Interval(0.0, 0.55,
                            curve: Curves.elasticOut),
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _drift,
                      builder: (_, child) {
                        final t = Curves.easeInOut.transform(_drift.value);
                        return Transform.translate(
                          offset: Offset(0, -4 * t),
                          child: child,
                        );
                      },
                      child: const Text(
                        '🎊',
                        style: TextStyle(fontSize: 56, height: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FadeSlideIn(
                    controller: _entrance,
                    interval: const Interval(0.40, 0.80,
                        curve: Curves.easeOutCubic),
                    child: const Text(
                      '당첨되었어요!',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _FadeSlideIn(
                    controller: _entrance,
                    interval: const Interval(0.55, 0.95,
                        curve: Curves.easeOut),
                    child: Text(
                      greeting,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 헤더 배경의 떠다니는 작은 ✨ ⭐ 들. progress 는 0..1..0 진동.
class _SparkleLayer extends StatelessWidget {
  const _SparkleLayer({required this.progress});
  final double progress;

  static const _items = <_Sparkle>[
    _Sparkle(emoji: '✨', dx: 0.10, dy: 0.20, size: 18, phase: 0.0),
    _Sparkle(emoji: '⭐', dx: 0.85, dy: 0.30, size: 14, phase: 0.25),
    _Sparkle(emoji: '✨', dx: 0.20, dy: 0.78, size: 16, phase: 0.55),
    _Sparkle(emoji: '⭐', dx: 0.78, dy: 0.74, size: 14, phase: 0.4),
    _Sparkle(emoji: '✨', dx: 0.50, dy: 0.10, size: 14, phase: 0.7),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          return Stack(
            children: [
              for (final s in _items)
                Positioned(
                  left: s.dx * w - s.size / 2,
                  top: s.dy * h +
                      math.sin((progress + s.phase) * math.pi * 2) * 8,
                  child: Opacity(
                    opacity: 0.55 +
                        0.30 * math.sin((progress + s.phase) * math.pi * 2),
                    child: Text(s.emoji,
                        style: TextStyle(fontSize: s.size, height: 1)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Sparkle {
  const _Sparkle({
    required this.emoji,
    required this.dx,
    required this.dy,
    required this.size,
    required this.phase,
  });
  final String emoji;
  final double dx;
  final double dy;
  final double size;
  final double phase;
}

/// fade + 살짝 위로 슬라이드.
class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({
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
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────
// 티켓 카드 — 썸네일 + 칩 + 제목 / 좌석 / 시야 / 일시·장소 / QR
// ─────────────────────────────────────
class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.application,
    required this.formatDateTime,
  });

  final LotteryApplication application;
  final String Function(DateTime) formatDateTime;

  @override
  Widget build(BuildContext context) {
    final perf = application.performance;
    final seats = application.assignedSeats;
    final stageView = seats.isNotEmpty &&
            seats.first.stageViewImageUrl.isNotEmpty
        ? seats.first.stageViewImageUrl
        : null;
    // 썸네일 위에 표시할 칩 텍스트 — subtitle 우선, 없으면 장르 라벨로 폴백.
    final chipLabel = (perf.subtitle != null && perf.subtitle!.isNotEmpty)
        ? perf.subtitle!
        : null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      elevation: 12,
      shadowColor: AppColors.primary.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1) 헤더 — 썸네일(좌) + 칩/제목(우)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 90,
                    height: 110,
                    child: CachedNetworkImage(
                      imageUrl: perf.posterImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: const Color(0xFFEDEDED)),
                      errorWidget: (_, __, ___) =>
                          Container(color: const Color(0xFFEDEDED)),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (chipLabel != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            chipLabel,
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        perf.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const _DashedDivider(),

          // 2) 좌석 — 큰 코랄 텍스트 강조
          if (seats.isNotEmpty) _SeatBlock(seats: seats),

          // 3) 예상 시야 (사진이 있을 때만)
          if (stageView != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: stageView,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: const Color(0xFFEDEDED)),
                          errorWidget: (_, __, ___) =>
                              Container(color: const Color(0xFFEDEDED)),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.visibility_outlined,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                '예상 시야',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 4) 일시 / 장소
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: Column(
              children: [
                _IconRow(
                  icon: Icons.calendar_today_rounded,
                  text: formatDateTime(perf.startDate),
                ),
                const SizedBox(height: 8),
                _IconRow(
                  icon: Icons.place_outlined,
                  text: perf.venue,
                ),
              ],
            ),
          ),

          const _DashedDivider(),

          // 5) QR — 코랄 톤 dashed 박스 안에
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomPaint(
                painter: _DashedBorderPainter(
                  color: AppColors.primary.withValues(alpha: 0.45),
                  radius: 16,
                  dashWidth: 6,
                  dashGap: 4,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomPaint(
                          painter: _QrPlaceholderPainter(
                            seed: seats.isNotEmpty ? seats.first.qrCode : '',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '공연장 입구에서\nQR 코드를 보여주세요',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '💡 화면 밝기가 자동으로 밝아져요',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 작은 아이콘 + 텍스트 한 줄.
class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

/// 둥근 사각형 영역 위에 dashed 외곽선을 그려주는 painter.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashWidth,
    required this.dashGap,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final metrics = path.computeMetrics();
    for (final m in metrics) {
      var dist = 0.0;
      while (dist < m.length) {
        final next = (dist + dashWidth).clamp(0.0, m.length);
        final extract = m.extractPath(dist, next);
        canvas.drawPath(extract, paint);
        dist = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeatBlock extends StatelessWidget {
  const _SeatBlock({required this.seats});
  final List<AssignedSeat> seats;

  @override
  Widget build(BuildContext context) {
    final first = seats.first;

    // 단일 좌석: "VIP석 1구역 A열 12번" 한 줄로.
    // 다중 좌석: 구역명 한 번 + 행/번호 여러 줄.
    final isSingle = seats.length == 1;
    final headerLabel = isSingle ? '내 좌석' : '내 좌석 (${seats.length}매)';

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_seat_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                headerLabel,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isSingle)
            Text(
              '${first.section} ${first.row} ${first.seatNumber}',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1.25,
              ),
            )
          else ...[
            Text(
              first.section,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            for (final s in seats)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '${s.row} ${s.seatNumber}',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.3,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, c) {
          const dashWidth = 6.0;
          const dashGap = 4.0;
          final count = (c.maxWidth / (dashWidth + dashGap)).floor();
          return Row(
            children: List.generate(count, (_) => _DashSegment())
                .expand((w) => [w, const SizedBox(width: dashGap)])
                .toList()
              ..removeLast(),
          );
        },
      ),
    );
  }
}

class _DashSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 6, height: 1, color: AppColors.border);
  }
}

/// QR placeholder — 결정론적 격자 패턴.
class _QrPlaceholderPainter extends CustomPainter {
  _QrPlaceholderPainter({required this.seed});
  final String seed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.textPrimary;
    const grid = 21;
    final cell = size.width / grid;
    final hash = seed.hashCode;

    for (int y = 0; y < grid; y++) {
      for (int x = 0; x < grid; x++) {
        // 모서리 finder pattern
        final inFinder =
            (x < 7 && y < 7) || (x >= grid - 7 && y < 7) || (x < 7 && y >= grid - 7);
        bool fill;
        if (inFinder) {
          final ax = x < 7 ? x : grid - 1 - x;
          final ay = y < 7 ? y : grid - 1 - y;
          fill = (ax == 0 || ax == 6 || ay == 0 || ay == 6) ||
              (ax >= 2 && ax <= 4 && ay >= 2 && ay <= 4);
        } else {
          fill = ((x * 31 + y * 17 + hash) & 0x7) > 3;
        }
        if (fill) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
