import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/presentation/auth_state.dart';

/// 홈 placeholder. 2단계에서 실제 화면 구현.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.storage,
    required this.authState,
  });

  final SecureStorage storage;
  final AuthState authState;

  Future<void> _logout(BuildContext context) async {
    await storage.clearTokens();
    authState.setAuthenticated(false);
    if (!context.mounted) return;
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('두근티켓 홈', style: AppTextStyles.displayLarge),
              const SizedBox(height: 8),
              Text(
                '아직 화면이 만들어지지 않았어요.\n다음 단계에서 구현됩니다.',
                style: AppTextStyles.bodyLarge,
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () => _logout(context),
                child: const Text('로그아웃'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
