import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/seat_preference.dart';
import '../../../providers/signup_provider.dart';

/// 회원가입 마지막 단계 — 좌석 선호도(신체 특성) 선택.
///
/// 백엔드 enum: NONE / EYESIGHT / LEG / HEARING.
/// 어르신 친화 UI: 한 화면 / 큰 카드 / 단일 선택.
class StepSeatPreference extends ConsumerWidget {
  const StepSeatPreference({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      signupProvider.select((s) => s.seatPreference),
    );
    final notifier = ref.read(signupProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('어떤 자리가 편하세요?', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '편한 자리를 추천해 드릴게요. 한 가지만 골라주세요.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          for (final option in SeatPreference.values) ...[
            _PreferenceCard(
              option: option,
              selected: selected == option,
              onTap: () => notifier.setSeatPreference(option),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final SeatPreference option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              option.emoji,
              style: const TextStyle(fontSize: 36, height: 1),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option.label, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    option.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
