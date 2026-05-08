import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

/// 부팅 화면.
///
/// 1) [AuthNotifier.bootstrap] 으로 토큰을 확인하고 사용자 정보 복원.
/// 2) 최소 2초 대기 (브랜드 인지) — 그 동안 마스코트 + 타이틀 cascade.
/// 3) 로그인 상태에 따라 [RouteNames.home] 또는 [RouteNames.onboarding] 으로 이동.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const Duration _minDuration = Duration(seconds: 2);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _drift;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _entrance.dispose();
    _drift.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // 마스코트 — elasticOut 으로 통통 등장 + 상시 부드럽게 떠오름
              ScaleTransition(
                scale: Tween<double>(begin: 0.4, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _entrance,
                    curve: const Interval(0.0, 0.55,
                        curve: Curves.elasticOut),
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _drift,
                  builder: (_, child) {
                    final t = Curves.easeInOut.transform(_drift.value);
                    return Transform.translate(
                      offset: Offset(0, -10 * t),
                      child: Transform.rotate(
                        angle: math.sin(_drift.value * math.pi * 2) * 0.04,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/selectIMG.png',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              _FadeSlide(
                controller: _entrance,
                interval:
                    const Interval(0.40, 0.80, curve: Curves.easeOutCubic),
                child: const Text(
                  '도담',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              _FadeSlide(
                controller: _entrance,
                interval: const Interval(0.55, 0.95, curve: Curves.easeOut),
                child: const Text(
                  '공연 티켓팅, 이젠 어렵지 않아요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xE6FFFFFF), // 90% white
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

/// fade + 살짝 위로 슬라이드.
class _FadeSlide extends StatelessWidget {
  const _FadeSlide({
    required this.controller,
    required this.interval,
    required this.child,
  });
  final AnimationController controller;
  final Interval interval;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: controller, curve: interval);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
