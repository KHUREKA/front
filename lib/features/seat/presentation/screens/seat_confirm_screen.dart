import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../home/domain/performance.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/mock_seat_repository.dart';
import '../../data/seat_repository.dart';
import '../../domain/seat_preference.dart';
import '../../domain/section.dart';
import '../providers/seat_preference_provider.dart';
import '../widgets/companion_counter.dart';

/// 응모 확인 화면.
///
/// - 동행자 매수 카운터
/// - 응모 요약 카드 (공연 + 순위 / AI / 매수 / 예상 결제)
/// - 노란 안내 박스
/// - 하단 "응모하기" 버튼 → 응모 후 /complete 로 이동
class SeatConfirmScreen extends ConsumerStatefulWidget {
  const SeatConfirmScreen({
    super.key,
    required this.performanceId,
  });

  final String performanceId;

  @override
  ConsumerState<SeatConfirmScreen> createState() => _SeatConfirmScreenState();
}

class _SeatConfirmScreenState extends ConsumerState<SeatConfirmScreen> {
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final pref = ref.read(seatPreferenceProvider);
      final repo = ref.read(seatRepositoryProvider);
      await repo.applyLottery(
        performanceId: widget.performanceId,
        preference: pref,
      );
      if (!mounted) return;
      context.go(RouteNames.seatCompleteFor(widget.performanceId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('응모 중 문제가 생겼어요. 다시 시도해주세요.'),
        ),
      );
      setState(() => _submitting = false);
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.seatModeFor(widget.performanceId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pref = ref.watch(seatPreferenceProvider);
    final asyncPerf =
        ref.watch(performanceByIdProvider(widget.performanceId));
    // 백엔드 /events/{id} 상세에는 가격이 없어 priceMin/Max 가 0으로 내려옴.
    // 그래서 좌석 zones 가 로드돼 있으면 거기서 실제 가격 범위를 끌어 쓴다.
    final asyncSections =
        ref.watch(sectionsProvider(widget.performanceId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: asyncPerf.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => FriendlyErrorView(
            title: '공연 정보를 불러오지 못했어요',
            description: '잠시 후 다시 시도해주세요',
            onRetry: () =>
                ref.invalidate(performanceByIdProvider(widget.performanceId)),
          ),
          data: (perf) {
            final sections = asyncSections.maybeWhen(
              data: (s) => s,
              orElse: () => const <Section>[],
            );
            final (priceMin, priceMax) = _resolvePriceRange(perf, sections);
            return _Content(
              performance: perf,
              preference: pref,
              priceMin: priceMin,
              priceMax: priceMax,
              submitting: _submitting,
              onIncrement: () => ref
                  .read(seatPreferenceProvider.notifier)
                  .incrementCompanion(),
              onDecrement: () => ref
                  .read(seatPreferenceProvider.notifier)
                  .decrementCompanion(),
              onSubmit: _submit,
              onBack: _back,
            );
          },
        ),
      ),
    );
  }

  /// zone 가격이 있으면 그 범위, 없으면 Performance 의 (대개 0인) 값.
  (int, int) _resolvePriceRange(Performance perf, List<Section> sections) {
    final prices =
        sections.map((s) => s.price).where((p) => p > 0).toList();
    if (prices.isNotEmpty) {
      prices.sort();
      return (prices.first, prices.last);
    }
    return (perf.priceMin, perf.priceMax);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.performance,
    required this.preference,
    required this.priceMin,
    required this.priceMax,
    required this.submitting,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSubmit,
    required this.onBack,
  });

  final Performance performance;
  final SeatPreference preference;
  final int priceMin;
  final int priceMax;
  final bool submitting;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  /// 응모 시점엔 어느 구역에 배정될지 모르므로, 공연 가격 범위의 평균으로
  /// 단순 추정. 표시는 "약 N원" 으로 약속 — 실제 결제 금액이 아님을 명시.
  int get _estimatedPrice {
    final avg = (priceMin + priceMax) ~/ 2;
    return avg * preference.companionCount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 28,
                  color: AppColors.textPrimary,
                ),
              ),
              Expanded(
                child: Text(
                  '응모 확인',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 동행자
                Text('함께 가는 분 포함, 몇 매 신청할까요?',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 16),
                CompanionCounter(
                  value: preference.companionCount,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
                const SizedBox(height: 8),
                Text(
                  '최대 4매까지 신청할 수 있어요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // 응모 요약
                _SummaryCard(
                  performance: performance,
                  preference: preference,
                  totalPrice: _estimatedPrice,
                ),

                const SizedBox(height: 16),

                // 안내
                const _InfoBox(),
              ],
            ),
          ),
        ),

        // CTA
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: submitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                textStyle: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: submitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text('응모하기'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.performance,
    required this.preference,
    required this.totalPrice,
  });

  final Performance performance;
  final SeatPreference preference;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    final priceFmt = NumberFormat('#,###');
    final dateText = PerformanceDateFormat.compactSingleDay(
      performance.startDate,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 공연 정보
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: performance.posterImageUrl,
                  width: 64,
                  height: 84,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(width: 64, height: 84, color: const Color(0xFFEDEDED)),
                  errorWidget: (_, __, ___) =>
                      Container(width: 64, height: 84, color: const Color(0xFFEDEDED)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      performance.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${performance.venue} · $dateText',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 32, color: AppColors.border),

          // 순위
          Text('내가 고른 순위',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              )),
          const SizedBox(height: 8),
          if (preference.mode == SeatPickMode.ai ||
              preference.rankedSectionIds.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 20, height: 1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI 가 가장 좋은 자리로 골라드려요',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < preference.rankedSectionIds.length; i++)
                  _RankRow(
                    rank: i + 1,
                    section: MockSeatRepository.sectionById(
                      preference.rankedSectionIds[i],
                    ),
                  ),
              ],
            ),

          const Divider(height: 32, color: AppColors.border),

          // 매수 / 예상 결제
          Row(
            children: [
              Text('매수',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  )),
              const Spacer(),
              Text('${preference.companionCount}매',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('예상 결제',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  )),
              const Spacer(),
              Text(
                '약 ${priceFmt.format(totalPrice)}원',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.rank, required this.section});
  final int rank;
  final Section? section;

  static const _emoji = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    if (section == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: section!.stageViewImageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(width: 44, height: 44, color: const Color(0xFFEDEDED)),
              errorWidget: (_, __, ___) =>
                  Container(width: 44, height: 44, color: const Color(0xFFEDEDED)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _emoji[rank - 1],
            style: const TextStyle(fontSize: 20, height: 1),
          ),
          const SizedBox(width: 6),
          Text(
            '$rank순위',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              section!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 20, height: 1)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '추첨에 당첨되면 자동으로 결제돼요.\n미당첨시 결제되지 않아요.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6E5500),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
