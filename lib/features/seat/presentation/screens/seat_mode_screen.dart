import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/seat_preference.dart';
import '../providers/seat_preference_provider.dart';

/// 좌석 선택 모드 선택 화면.
///
/// - 좌상단 ← 뒤로
/// - 큰 제목 "좌석 선택 방식을 골라주세요."
/// - 두 개의 큰 모드 카드 (세로 스택):
///   * 코랄 fill: 알아서 척척, AI 추천받기
///   * 흰 fill + 보더: 사진으로 보고, 직접 고르기
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
    // 새 공연 시작 시 좌석 선호 초기화.
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 뒤로
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: _back,
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 제목
              Text(
                '좌석 선택 방식을\n골라주세요.',
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 30,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 28),

              // 카드들
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _ModeCard(
                        filled: true,
                        emoji: '🤖',
                        title: '알아서 척척, AI 추천받기',
                        description: '당첨 가능성이 가장 높은 자리를\nAI가 대신 찾아드려요.',
                        onTap: _selectAi,
                      ),
                      const SizedBox(height: 16),
                      _ModeCard(
                        filled: false,
                        emoji: '🔍',
                        title: '사진으로 보고, 직접 고르기',
                        description: '실제 무대 모습과 이동이 편한 자리를\n사진으로 보고 직접 고를 수 있어요.',
                        onTap: _selectManual,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 모드 선택 카드.
///
/// 첨부 이미지 스타일을 따른다:
/// - 카드 상단: 흰색 라운드 박스 안에 큰 일러스트 영역(이모지로 대체)
/// - 카드 하단: 제목 + 설명 (좌측 정렬)
/// - filled = true → 코랄 풀 카드, 흰 텍스트
/// - filled = false → 흰 카드 + 옅은 보더, 어두운 텍스트
class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.filled,
    required this.emoji,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final bool filled;
  final String emoji;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.primary : const Color(0xFFEEEEEE);
    final illustrationBg = filled
        ? Colors.white
        : Colors.white;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 일러스트 영역
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: illustrationBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 72, height: 1),
                ),
              ),

              const SizedBox(height: 18),

              // 제목
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),

              // 설명
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
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
