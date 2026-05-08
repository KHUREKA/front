import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/flow_app_bar.dart';
import '../../domain/seat_preference.dart';
import '../providers/seat_preference_provider.dart';

class SeatModeScreen extends ConsumerStatefulWidget {
  const SeatModeScreen({
    super.key,
    required this.performanceId,
  });

  final String performanceId;

  @override
  ConsumerState<SeatModeScreen> createState() => _SeatModeScreenState();
}

class _SeatModeScreenState extends ConsumerState<SeatModeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(seatPreferenceProvider.notifier).reset();
    });
  }

  void _selectAi() {
    ref.read(seatPreferenceProvider.notifier).setMode(SeatPickMode.ai);
    context.push(RouteNames.seatConfirmFor(widget.performanceId));
  }

  void _selectManual() {
    ref.read(seatPreferenceProvider.notifier).setMode(SeatPickMode.manual);
    context.push(RouteNames.seatSwipeFor(widget.performanceId));
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 통합 헤더: 뒤로 ◀ — 진행바 — 닫기 ✕
            FlowAppBar(
              step: 1,
              total: 3,
              onBack: _back,
              onClose: _back,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimationLimiter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 제목
                      _cascade(
                        0,
                        Text(
                          '좌석 선택 방식을\n골라주세요.',
                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 30,
                            height: 1.35,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // 카드들 - 고정 높이
                      _cascade(
                        1,
                        SizedBox(
                          height: 320,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _ModeCard(
                                  filled: true,
                                  imageAsset: 'assets/images/aiIMG.png',
                                  title: 'AI 추천받기',
                                  description: '당첨 가능성 높은 자리 추천',
                                  onTap: _selectAi,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ModeCard(
                                  filled: false,
                                  imageAsset: 'assets/images/selectIMG.png',
                                  title: '직접 고르기',
                                  description: '사진 보고 내가 직접 선택',
                                  onTap: _selectManual,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 안내 박스 - 카드 선택 도움말
                      _cascade(
                        2,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '처음이시라면 AI 추천을 받아보세요.\n당첨 확률이 높은 자리를 골라드려요.',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),
                    ],
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

/// 좌석 선택 방식 화면용 cascade 래퍼.
///
/// Sequential — 한 항목이 끝나야 다음 항목 시작 (delay == duration).
/// 한 단계당 1.2초.
Widget _cascade(int position, Widget child) =>
    AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 1200),
      delay: const Duration(milliseconds: 1200),
      child: SlideAnimation(
        verticalOffset: 30.0,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(curve: Curves.easeOut, child: child),
      ),
    );

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.filled,
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final bool filled;
  final String imageAsset;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.primary : const Color(0xFFEEEEEE);
    final titleColor = filled ? Colors.white : AppColors.textPrimary;
    final descColor =
        filled ? Colors.white.withValues(alpha: 0.92) : AppColors.textSecondary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 일러스트 영역
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 제목
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),

              // 설명
              Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: descColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
