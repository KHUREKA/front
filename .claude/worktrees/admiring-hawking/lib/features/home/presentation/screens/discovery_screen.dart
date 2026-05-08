import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 히어로 카드 → "/discovery" placeholder.
/// 다음 단계에서 AI 추천 흐름 (관심사·예산·날짜 입력 → 추천) 으로 구현.
class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('구경거리 찾기')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.auto_awesome_outlined,
                size: 96,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'AI가 딱 맞는 공연을 찾아드릴 거예요',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '이 화면은 다음 단계에서 만들 예정이에요.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
