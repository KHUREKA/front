import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../home/presentation/providers/home_provider.dart';
import '../../providers/auth_provider.dart';

/// 회원가입 완료 직후 보여주는 환영 화면.
///
/// - 코랄 그라데이션 + 떠다니는 축하 이모지 + 단계별 등장 애니메이션
/// - 홈 데이터(`homeEventsProvider`)를 미리 로드해두고, 최소 2초 / 최대 6초 안에서
///   준비되면 `/home` 으로 이동 — 홈 진입 시 빈 화면 깜박임 없음
class SignupCompleteScreen extends ConsumerStatefulWidget {
  const SignupCompleteScreen({super.key});

  @override
  ConsumerState<SignupCompleteScreen> createState() =>
      _SignupCompleteScreenState();
}

class _SignupCompleteScreenState extends ConsumerState<SignupCompleteScreen>
    with TickerProviderStateMixin {
  // 단계별 등장.
  late final AnimationController _entrance;
  // 떠다니는 이모지 / 빛나는 빛 — 부드럽게 반복.
  late final AnimationController _drift;

  bool _minWaitPassed = false;
  bool _homeReady = false;
  bool _navigated = false;

  Timer? _minWaitTimer;
  Timer? _maxWaitTimer;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // 홈 데이터 + 카드 이미지 프리로드 — 진입 즉시 카드가 보이도록.
    Future.microtask(() async {
      try {
        final home = await ref.read(homeEventsProvider.future);
        // 이미지도 미리 디코드/캐시 — cached_network_image 의 첫 호출 race 회피.
        if (mounted) {
          for (final e in [
            ...home.nearbyEvents,
            ...home.recommendedEvents,
          ]) {
            final url = e.thumbnailUrl;
            if (url != null && url.isNotEmpty) {
              // ignore: use_build_context_synchronously
              precacheImage(CachedNetworkImageProvider(url), context);
            }
          }
        }
      } catch (_) {
        // 실패해도 홈 화면이 알아서 에러 UI 를 띄우므로 그냥 진행.
      }
      if (!mounted) return;
      setState(() => _homeReady = true);
      _maybeNavigate();
    });

    // 최소 2초는 보여주기 (어르신이 완료 메시지를 충분히 읽도록).
    _minWaitTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _minWaitPassed = true);
      _maybeNavigate();
    });

    // 최대 6초 — 네트워크가 너무 느려도 멈춰있지 않도록 안전장치.
    _maxWaitTimer = Timer(const Duration(seconds: 6), () {
      if (!mounted) return;
      _navigate();
    });
  }

  void _maybeNavigate() {
    if (_minWaitPassed && _homeReady) _navigate();
  }

  void _navigate() {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go(RouteNames.home);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _drift.dispose();
    _minWaitTimer?.cancel();
    _maxWaitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final greeting = user != null ? '${user.name}님,' : '환영합니다,';

    return Scaffold(
      body: Stack(
        children: [
          // 1. 코랄 그라데이션 배경
          const _GradientBackground(),

          // 2. 떠다니는 축하 이모지
          AnimatedBuilder(
            animation: _drift,
            builder: (_, __) =>
                _ConfettiLayer(progress: _drift.value),
          ),

          // 3. 중앙 콘텐츠
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  _AnimatedBadge(controller: _entrance),
                  const SizedBox(height: 36),
                  _FadeSlideIn(
                    controller: _entrance,
                    interval: const Interval(0.40, 0.80,
                        curve: Curves.easeOutCubic),
                    child: Text(
                      greeting,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FadeSlideIn(
                    controller: _entrance,
                    interval: const Interval(0.55, 0.95,
                        curve: Curves.easeOut),
                    child: Text(
                      '도담 가족이 되신 걸\n환영해요 💝',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 19,
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                  // 하단 — 홈 로딩 안내 (준비되면 사라짐)
                  _BottomStatus(homeReady: _homeReady),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// 배경 그라데이션
// ─────────────────────────────────────────
class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF8A8F), // primary 보다 살짝 밝게
            AppColors.primary,
            AppColors.primaryDark,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

// ─────────────────────────────────────────
// 떠다니는 축하 이모지 — 부드럽게 위아래 sin 진동
// ─────────────────────────────────────────
class _ConfettiLayer extends StatelessWidget {
  const _ConfettiLayer({required this.progress});

  /// 0..1..0 (reverse repeat).
  final double progress;

  static const _items = <_ConfettiSpec>[
    _ConfettiSpec(emoji: '✨', dx: 0.10, dy: 0.18, size: 28, phase: 0.0),
    _ConfettiSpec(emoji: '🎊', dx: 0.85, dy: 0.20, size: 36, phase: 0.3),
    _ConfettiSpec(emoji: '🎉', dx: 0.18, dy: 0.78, size: 34, phase: 0.6),
    _ConfettiSpec(emoji: '💝', dx: 0.78, dy: 0.74, size: 30, phase: 0.2),
    _ConfettiSpec(emoji: '⭐', dx: 0.50, dy: 0.10, size: 22, phase: 0.45),
    _ConfettiSpec(emoji: '✨', dx: 0.65, dy: 0.55, size: 24, phase: 0.7),
    _ConfettiSpec(emoji: '⭐', dx: 0.12, dy: 0.45, size: 18, phase: 0.85),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          children: [
            for (final c in _items)
              Positioned(
                left: c.dx * size.width - c.size / 2,
                top: c.dy * size.height +
                    math.sin((progress + c.phase) * math.pi * 2) * 10,
                child: Opacity(
                  opacity: 0.55 +
                      0.25 *
                          math.sin((progress + c.phase) * math.pi * 2),
                  child: Text(
                    c.emoji,
                    style: TextStyle(fontSize: c.size, height: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiSpec {
  const _ConfettiSpec({
    required this.emoji,
    required this.dx,
    required this.dy,
    required this.size,
    required this.phase,
  });
  final String emoji;
  final double dx; // 0..1
  final double dy; // 0..1
  final double size;
  final double phase; // 0..1
}

// ─────────────────────────────────────────
// 중앙 배지 — 흰 원 안에 🎉, 통통 튀는 등장
// ─────────────────────────────────────────
class _AnimatedBadge extends StatelessWidget {
  const _AnimatedBadge({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final scale = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(scale),
      child: Container(
        width: 156,
        height: 156,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.35),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text('🎉', style: TextStyle(fontSize: 88, height: 1)),
      ),
    );
  }
}

// ─────────────────────────────────────────
// fade + 살짝 위로 슬라이드
// ─────────────────────────────────────────
class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({
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

// ─────────────────────────────────────────
// 하단 — 홈이 아직 준비 중이면 작은 안내, 준비되면 사라짐
// ─────────────────────────────────────────
class _BottomStatus extends StatelessWidget {
  const _BottomStatus({required this.homeReady});
  final bool homeReady;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: homeReady
          ? const SizedBox(height: 28, key: ValueKey('ready'))
          : Row(
              key: const ValueKey('loading'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '잠시만 기다려주세요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
