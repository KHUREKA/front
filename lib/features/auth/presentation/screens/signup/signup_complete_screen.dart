import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';

/// 회원가입 완료 직후 잠깐 보여주는 환영 화면.
/// 2초 후 자동으로 [RouteNames.home] 으로 이동.
class SignupCompleteScreen extends ConsumerStatefulWidget {
  const SignupCompleteScreen({super.key});

  @override
  ConsumerState<SignupCompleteScreen> createState() =>
      _SignupCompleteScreenState();
}

class _SignupCompleteScreenState extends ConsumerState<SignupCompleteScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go(RouteNames.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final greeting =
        user != null ? '${user.name}님,' : '환영합니다,';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '🎉',
                  style: TextStyle(fontSize: 64, height: 1),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                greeting,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '두근티켓 가족이 되신 걸 환영해요',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
