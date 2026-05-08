import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';

/// 회원가입 placeholder. 2단계에서 단계별로 분리 구현.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('회원가입 화면', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                '아직 화면이 만들어지지 않았어요.\n다음 단계에서 구현됩니다.',
                style: AppTextStyles.bodyLarge,
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () => context.go(RouteNames.login),
                child: const Text('로그인으로 돌아가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
