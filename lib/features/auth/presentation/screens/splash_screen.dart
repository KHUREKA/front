import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

/// 부팅 화면.
///
/// 1) [AuthNotifier.bootstrap] 으로 토큰을 확인하고 사용자 정보 복원.
/// 2) 최소 2초 대기 (브랜드 인지).
/// 3) 로그인 상태에 따라 [RouteNames.home] 또는 [RouteNames.onboarding] 으로 이동.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const Duration _minDuration = Duration(seconds: 2);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final started = DateTime.now();
    await ref.read(authProvider.notifier).bootstrap();

    final elapsed = DateTime.now().difference(started);
    final remaining = SplashScreen._minDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    if (!mounted) return;
    final isAuth = ref.read(authProvider).isAuthenticated;
    context.go(isAuth ? RouteNames.home : RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '도담',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '공연 티켓팅, 이젠 어렵지 않아요',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xE6FFFFFF), // 90% white
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

