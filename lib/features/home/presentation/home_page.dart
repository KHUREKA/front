import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/presentation/providers/auth_provider.dart';

/// 홈 placeholder. 다음 단계에서 실제 콘텐츠로 교체.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final greetingName = user?.name ?? '회원';

    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                '$greetingName님,\n환영해요!',
                style: AppTextStyles.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '홈 화면은 다음 단계에서 만들 예정이에요.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  // 라우터의 redirect 가드가 자동으로 /login 으로 이동시킴.
                },
                child: const Text('로그아웃'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
