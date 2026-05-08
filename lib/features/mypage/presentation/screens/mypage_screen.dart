import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/main_bottom_navigation.dart';
import '../../../../shared/widgets/main_tab_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 마이 화면 placeholder. 실제 구현은 추후 단계에서.
/// 지금은 사용자 정보 + 로그아웃만 제공.
class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return MainTabScaffold(
      currentTab: MainTab.mypage,
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text('마이', style: AppTextStyles.displayLarge),
              const SizedBox(height: 24),
              if (user != null) _UserInfoCard(name: user.name, email: user.email),
              const SizedBox(height: 24),
              Text(
                '마이페이지는 다음 단계에서 만들 예정이에요.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  // 라우터 가드가 자동으로 /login 이동.
                },
                child: const Text('로그아웃'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({required this.name, required this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name.characters.first : '?',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${name}님', style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
