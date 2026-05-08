import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';

/// 온보딩 placeholder. 2단계에서 실제 화면 구현.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('온보딩', style: AppTextStyles.displayLarge),
              const SizedBox(height: 16),
              Text(
                '두근티켓에 오신 것을 환영합니다.',
                style: AppTextStyles.bodyLarge,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(RouteNames.login),
                child: const Text('시작하기'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(RouteNames.signup),
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
