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
              SliverToBoxAdapter(
                child: _CelebrationHeader(
                  onClose: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RouteNames.lottery);
                    }
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Transform.translate(
                    offset: const Offset(0, -32),
                    child: _TicketCard(
                      application: app,
                      formatDateTime: _formatDateTime,
                    ),
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
                      onCopyAddress: () => _copyAddress(context, info),
                      onOpenMap: () => _openKakaoMap(context, info),
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
// 상단 축하 헤더
// ─────────────────────────────────────
class _CelebrationHeader extends StatelessWidget {
  const _CelebrationHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded,
                    size: 28, color: Colors.white),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 48, height: 1)),
                  const SizedBox(height: 8),
                  Text(
                    '당첨되었어요!',
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '축하드려요',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.95),
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

// ─────────────────────────────────────
// 티켓 카드
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

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      elevation: 12,
      shadowColor: AppColors.primary.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 포스터 풀블리드
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: perf.posterImageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: const Color(0xFFEDEDED)),
              errorWidget: (_, __, ___) =>
                  Container(color: const Color(0xFFEDEDED)),
            ),
          ),

          // 정보
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  perf.title,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        formatDateTime(perf.startDate),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.place_outlined,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        perf.venue,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const _DashedDivider(),

          // 좌석 정보 (1~4매)
          if (seats.isNotEmpty) _SeatBlock(seats: seats),

          const _DashedDivider(),

          // QR placeholder
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomPaint(
                    painter: _QrPlaceholderPainter(
                      seed: seats.isNotEmpty ? seats.first.qrCode : '',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '공연장 입구에서\nQR 코드를 보여주세요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SeatBlock extends StatelessWidget {
  const _SeatBlock({required this.seats});
  final List<AssignedSeat> seats;

  @override
  Widget build(BuildContext context) {
    final first = seats.first;
    // 같은 응모 안의 좌석은 같은 구역에 배정되므로 section 은 첫 좌석 기준 한 번만.
    final hasView = first.stageViewImageUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내 좌석 (${seats.length}매)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  first.section,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                for (final s in seats)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${s.row} ${s.seatNumber}',
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (hasView)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: first.stageViewImageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 80,
                  height: 80,
                  color: const Color(0xFFEDEDED),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: const Color(0xFFEDEDED),
                ),
              ),
            ),
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
