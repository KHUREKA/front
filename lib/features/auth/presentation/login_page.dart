import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import 'auth_state.dart';

/// 로그인 placeholder. 2단계에서 실제 화면 구현.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('로그인 화면', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                '아직 화면이 만들어지지 않았어요.\n다음 단계에서 구현됩니다.',
                style: AppTextStyles.bodyLarge,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // 임시: 가짜 로그인 → 인증 가드 통과 확인용
                  authState.setAuthenticated(true);
                  context.go(RouteNames.home);
                },
                child: const Text('확인 (임시 로그인)'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(RouteNames.signup),
                child: const Text('회원가입으로 이동'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
