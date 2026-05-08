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
import '../../../seat/domain/seat_preference.dart';
import '../../data/applications_repository.dart';
import '../../domain/lottery_application.dart';
import '../../domain/lottery_status.dart';
import '../providers/applications_provider.dart';

/// 응모 상세 화면.
///
/// 당첨 응모는 [WonTicketScreen] 으로 우회 (이 화면은 비당첨/대기/지난 응모 위주).
/// 상태별로 하단 액션 버튼이 달라짐.
class ApplicationDetailScreen extends ConsumerWidget {
  const ApplicationDetailScreen({
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
    final mm = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}년 ${dt.month}월 ${dt.day}일 ($wd) $ampm $h12:$mm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncApp = ref.watch(applicationDetailProvider(applicationId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.lottery);
            }
          },
        ),
        title: Text(
          '응모 내역',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: asyncApp.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => FriendlyErrorView(
            title: '응모 정보를 불러오지 못했어요',
            description: '잠시 후 다시 시도해주세요',
            onRetry: () =>
                ref.invalidate(applicationDetailProvider(applicationId)),
          ),
          data: (app) {
            // 당첨 케이스는 티켓 화면으로 자동 우회.
            if (app.status == LotteryStatus.won) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.go(RouteNames.applicationTicketFor(app.id));
                }
              });
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            return _Body(application: app, formatDateTime: _formatDateTime);
          },
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.application,
    required this.formatDateTime,
  });

  final LotteryApplication application;
  final String Function(DateTime) formatDateTime;

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('정말 응모를 취소하시겠어요?'),
        content: const Text(
          '취소 후에는 되돌릴 수 없어요.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        // 위계 분리: 파괴적(취소)은 빨강 텍스트, 권장(계속)은 채워진 버튼.
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(
              '취소할게요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '계속 응모할게요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref
          .read(applicationsRepositoryProvider)
          .cancelApplication(application.id);
      ref.invalidate(applicationDetailProvider(application.id));
      ref.invalidate(pendingApplicationsProvider);
      ref.invalidate(pastApplicationsProvider);
      ref.invalidate(userStatsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('응모를 취소했어요.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perf = application.performance;
    final priceFmt = NumberFormat('#,###');

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        // 1. 공연 카드
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: perf.posterImageUrl,
                width: 100,
                height: 134,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 100,
                  height: 134,
                  color: const Color(0xFFEDEDED),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 100,
                  height: 134,
                  color: const Color(0xFFEDEDED),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perf.title,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    perf.venue,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    PerformanceDateFormat.span(perf.startDate, perf.endDate),
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 2. 응모 정보 박스
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoRow(label: '응모일', value: formatDateTime(application.appliedAt)),
              const SizedBox(height: 8),
              _InfoRow(
                  label: '추첨 발표', value: formatDateTime(application.lotteryDate)),
              const SizedBox(height: 8),
              _InfoRow(
                  label: '매수', value: '${application.companionCount}매'),
              const SizedBox(height: 8),
              _InfoRow(
                label: '좌석 선택 방식',
                value: application.pickMode == SeatPickMode.ai
                    ? 'AI가 골라줌'
                    : '직접 선택',
              ),
            ],
          ),
        ),

        // 3. 직접 선택 시 순위
        if (application.pickMode == SeatPickMode.manual &&
            application.rankedSectionNames.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            '내가 고른 순위',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < application.rankedSectionNames.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RankRow(
                rank: i + 1,
                name: application.rankedSectionNames[i],
              ),
            ),
        ],

        const SizedBox(height: 24),

        // 4. 결제 정보
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('예상 결제 금액',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        )),
                  ),
                  Text(
                    '${priceFmt.format(application.totalPrice)}원',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _InfoRow(label: '결제 수단', value: application.paymentMethod),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡', style: TextStyle(fontSize: 16, height: 1)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '미당첨 시 결제되지 않아요.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6E5500),
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

        const SizedBox(height: 28),

        // 5. 상태별 액션
        _StatusAction(
          status: application.status,
          onCancel: () => _confirmCancel(context, ref),
          onSimilar: () => context.go(RouteNames.discovery),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.rank, required this.name});
  final int rank;
  final String name;

  static const _emoji = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(_emoji[rank - 1],
              style: const TextStyle(fontSize: 22, height: 1)),
          const SizedBox(width: 8),
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
              name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusAction extends StatelessWidget {
  const _StatusAction({
    required this.status,
    required this.onCancel,
    required this.onSimilar,
  });

  final LotteryStatus status;
  final VoidCallback onCancel;
  final VoidCallback onSimilar;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LotteryStatus.pending:
        return SizedBox(
          height: 56,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border, width: 1.5),
              textStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text('응모 취소하기'),
          ),
        );
      case LotteryStatus.lost:
        return SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: onSimilar,
            icon: const Icon(Icons.auto_awesome_rounded, size: 22),
            label: const Text('비슷한 공연 보기'),
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
        );
      case LotteryStatus.completed:
        return SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('후기 기능은 준비 중이에요.')),
              );
            },
            icon: const Icon(Icons.edit_note_rounded, size: 22),
            label: const Text('후기 남기기'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
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
        );
      case LotteryStatus.cancelled:
      case LotteryStatus.won:
        return const SizedBox.shrink();
    }
  }
}
