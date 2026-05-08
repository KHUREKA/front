import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'auth_state.dart';

/// 부팅 시 토큰을 확인하고 적절한 화면으로 분기하는 스플래시.
class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.storage,
    required this.authState,
  });

  final SecureStorage storage;
  final AuthState authState;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final hasToken = await widget.storage.hasAccessToken();
    widget.authState.setAuthenticated(hasToken);

    if (!mounted) return;
    context.go(hasToken ? RouteNames.home : RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('두근티켓', style: AppTextStyles.displayLarge),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
