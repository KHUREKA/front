import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/flow_app_bar.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../domain/seat_preference.dart';
import '../../domain/section.dart';
import '../providers/seat_preference_provider.dart';
import '../widgets/ai_suggest_button.dart';
import '../widgets/ranking_slots.dart';
import '../widgets/section_card_stack.dart';

/// 구역 뷰를 PageView 로 좌우 이동하면서 1·2·3순위를 정하는 화면.
///
/// 인터랙션:
/// - 좌우 스와이프: 이전/다음 구역 (사라지지 않음)
/// - 카드 탭 또는 아래로 드래그: 현재 구역을 순위 슬롯에 추가
/// - "마음에 들어요" 버튼 ⬇: 현재 구역을 슬롯에 추가
/// - ◀/▶ 큰 원형 버튼: 이전/다음 구역으로 이동 (어르신 친화)
/// - "AI가 정해주기": 다이얼로그 후 AI 모드로 전환
class SeatSwipeScreen extends ConsumerStatefulWidget {
  const SeatSwipeScreen({
    super.key,
    required this.performanceId,
  });

  final String performanceId;

  @override
  ConsumerState<SeatSwipeScreen> createState() => _SeatSwipeScreenState();
}

class _SeatSwipeScreenState extends ConsumerState<SeatSwipeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newIndex) {
    setState(() => _currentIndex = newIndex);
  }

  void _addToRank(Section section) {
    ref.read(seatPreferenceProvider.notifier).pushRank(section.id);
  }

  void _next(int total) {
    if (_currentIndex >= total - 1) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _prev() {
    if (_currentIndex <= 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _switchToAi() {
    ref.read(seatPreferenceProvider.notifier).setMode(SeatPickMode.ai);
    context.push(RouteNames.seatConfirmFor(widget.performanceId));
  }

  void _goToConfirm() {
    context.push(RouteNames.seatConfirmFor(widget.performanceId));
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.seatModeFor(widget.performanceId));
    }
  }

  void _exitToHome() {
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final asyncSections = ref.watch(sectionsProvider(widget.performanceId));
    final pref = ref.watch(seatPreferenceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: asyncSections.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => FriendlyErrorView(
            title: '구역 정보를 불러오지 못했어요',
            description: '잠시 후 다시 시도해주세요',
            onRetry: () =>
                ref.invalidate(sectionsProvider(widget.performanceId)),
          ),
          data: (sections) => _Body(
            sections: sections,
            currentIndex: _currentIndex,
            rankedIds: pref.rankedSectionIds,
            pageController: _pageController,
            onPageChanged: _onPageChanged,
            onAddToRank: _addToRank,
            onNext: () => _next(sections.length),
            onPrev: _prev,
            onAiTap: _switchToAi,
            onBack: _back,
            onExit: _exitToHome,
            onRemoveRank: (id) =>
                ref.read(seatPreferenceProvider.notifier).removeRank(id),
            onSubmit: pref.hasAnyRank ? _goToConfirm : null,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.sections,
    required this.currentIndex,
    required this.rankedIds,
    required this.pageController,
    required this.onPageChanged,
    required this.onAddToRank,
    required this.onNext,
    required this.onPrev,
    required this.onAiTap,
    required this.onBack,
    required this.onExit,
    required this.onRemoveRank,
    required this.onSubmit,
  });

  final List<Section> sections;
  final int currentIndex;
  final List<String> rankedIds;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Section> onAddToRank;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onAiTap;
  final VoidCallback onBack;
  final VoidCallback onExit;
  final ValueChanged<String> onRemoveRank;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < sections.length - 1;
    final canAddMore = rankedIds.length < SeatPreference.maxRanks;

    final currentSection =
        sections.isEmpty ? null : sections[currentIndex.clamp(0, sections.length - 1)];
    final isCurrentRanked =
        currentSection != null && rankedIds.contains(currentSection.id);
    final canLikeCurrent = canAddMore && !isCurrentRanked;

    return AnimationLimiter(
      child: Column(
        children: [
          // 통합 헤더: 뒤로 ◀ — 진행바 (2/3) — 닫기 ✕
          FlowAppBar(
            step: 2,
            total: 3,
            onBack: onBack,
            onClose: onExit,
          ),
          // AI 모드 전환 버튼 (헤더 아래 우측)
          _cascade(
            0,
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  const Spacer(),
                  AiSuggestButton(onConfirm: onAiTap),
                ],
              ),
            ),
          ),

          // 카드 페이저 (cascade 밖 — Expanded 는 Flex 직계여야 함)
          Expanded(
            child: Stack(
              children: [
                SectionPager(
                  sections: sections,
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  onAddToRank: onAddToRank,
                  rankedIds: rankedIds,
                ),

                // 카드 위 중앙 상단 — 진행 표시 알약
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: _ProgressPill(
                        current: currentIndex + 1,
                        total: sections.length,
                      ),
                    ),
                  ),
                ),

                // ◀ 이전 (좌측)
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _ArrowButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      enabled: hasPrev,
                      onTap: hasPrev ? onPrev : null,
                    ),
                  ),
                ),

                // ▶ 다음 (우측)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _ArrowButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      enabled: hasNext,
                      onTap: hasNext ? onNext : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // "마음에 들어요" 버튼 (현재 카드를 슬롯에 추가)
          _cascade(
            1,
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: _LikeButton(
                enabled: canLikeCurrent,
                label: isCurrentRanked
                    ? '이미 골랐어요'
                    : (canAddMore ? '마음에 들어요' : '순위가 다 찼어요'),
                onTap: canLikeCurrent && currentSection != null
                    ? () => onAddToRank(currentSection)
                    : null,
              ),
            ),
          ),

          // 순위 슬롯
          _cascade(
            2,
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: RankingSlots(
                rankedSectionIds: rankedIds,
                onRemove: onRemoveRank,
              ),
            ),
          ),

          // CTA
          _cascade(
            3,
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.textTertiary,
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
                  child: Text(
                    onSubmit == null ? '최소 1개 이상 골라주세요' : '이 순위로 응모하기',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 섹션 순위 화면용 cascade 래퍼.
///
/// Sequential — 한 항목이 끝나야 다음 항목 시작 (delay == duration).
/// 한 단계당 1.1초. 페이저 자체는 cascade 밖 — Expanded 는 Flex 직계여야 함.
Widget _cascade(int position, Widget child) =>
    AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 1100),
      delay: const Duration(milliseconds: 1100),
      child: SlideAnimation(
        verticalOffset: 36.0,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(curve: Curves.easeOut, child: child),
      ),
    );

/// 카드 위 중앙 상단 — "N / N 구역 보는 중" 알약 인디케이터.
class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_seat_rounded,
              size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            '$current / $total 구역 보는 중',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// 카드 아래의 "마음에 들어요" 큰 버튼.
///
/// - 아래 화살표 ⬇ 아이콘 (드래그 방향과 일치)
/// - 56dp, 코랄 fill, 활성/비활성 상태 분기
class _LikeButton extends StatelessWidget {
  const _LikeButton({
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primary : AppColors.border,
      borderRadius: BorderRadius.circular(28),
      elevation: enabled ? 4 : 0,
      shadowColor: AppColors.primary.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_downward_rounded,
                size: 24,
                color: enabled ? Colors.white : AppColors.textTertiary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: enabled ? Colors.white : AppColors.textTertiary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 카드 좌/우의 이전/다음 원형 버튼.
class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        enabled ? AppColors.textPrimary : AppColors.textTertiary;
    return Material(
      color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.7),
      shape: const CircleBorder(),
      elevation: enabled ? 6 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, size: 24, color: iconColor),
        ),
      ),
    );
  }
}
