import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 응모내역 화면 placeholder. 실제 구현은 추후 단계에서.
///
/// 외곽 Scaffold/하단 네비는 [MainTabShell] 이 제공한다.
class LotteryScreen extends StatelessWidget {
  const LotteryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text('응모내역', style: AppTextStyles.displayLarge),
            const Spacer(),
            const Icon(
              Icons.confirmation_number_outlined,
              size: 96,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 24),
            Text(
              '아직 응모하신 공연이 없어요',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '홈에서 마음에 드는 공연을 찾아보세요.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
