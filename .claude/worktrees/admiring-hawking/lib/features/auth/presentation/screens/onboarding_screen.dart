import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 첫 진입 시 보여주는 3장짜리 온보딩.
///
/// 페이지 전환할 때마다 [_OnboardingPage] 가 새 위젯 트리로 들어가
/// entrance 애니메이션이 다시 재생된다 (`ValueKey<int>`).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const List<_PageData> _pages = [
    _PageData(
      emoji: '🎫',
      title: '복잡한 티켓팅,\n이젠 어렵지 않아요',
      subtitle: '도담이 어려운 과정을\n대신 처리해드려요.',
    ),
    _PageData(
      emoji: '🤖',
      title: 'AI가 좌석까지\n알아서 골라드려요',
      subtitle: '원하는 자리를 미리 알려주시면\n빠르게 잡아드려요.',
    ),
    _PageData(
      emoji: '🎉',
      title: '당첨되면\n교통편까지 알려드려요',
      subtitle: '공연장 가는 길과 시간을\n친절하게 안내해드려요.',
    ),
  ];

  bool get _isLast => _currentPage == _pages.length - 1;

  void _next() {
    if (_isLast) {
      context.go(RouteNames.login);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 우상단 "건너뛰기"
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 8),
                child: TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: const Text('건너뛰기'),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _OnboardingPage(
                  key: ValueKey<int>(i),
                  data: _pages[i],
                ),
              ),
            ),

            // 도트 인디케이터
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _currentPage
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),

            // 다음 / 시작하기 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(_isLast ? '시작하기' : '다음'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  const _PageData({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
  final String emoji;
  final String title;
  final String subtitle;
}

class _OnboardingPage extends StatefulWidget {
  const _OnboardingPage({super.key, required this.data});
  final _PageData data;

  @override
  State<_OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<_OnboardingPage>
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
  }

  @override
  void dispose() {
    _entrance.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 일러스트 버블 — scale 등장 + 떠다니는 sparkle + 안의 이모지 bob
          SizedBox(
            width: 280,
            height: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _drift,
                  builder: (_, __) =>
                      _BubbleSparkles(progress: _drift.value),
                ),
                ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _entrance,
                      curve: const Interval(0.0, 0.55,
                          curve: Curves.elasticOut),
                    ),
                  ),
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                      animation: _drift,
                      builder: (_, child) {
                        final t = Curves.easeInOut.transform(_drift.value);
                        return Transform.translate(
                          offset: Offset(0, -8 * t),
                          child: Transform.rotate(
                            angle: (t - 0.5) * 0.06,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        widget.data.emoji,
                        style: const TextStyle(fontSize: 96, height: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _FadeSlide(
            controller: _entrance,
            interval:
                const Interval(0.40, 0.80, curve: Curves.easeOutCubic),
            child: Text(
              widget.data.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLarge.copyWith(fontSize: 26),
            ),
          ),
          const SizedBox(height: 16),
          _FadeSlide(
            controller: _entrance,
            interval: const Interval(0.55, 0.95, curve: Curves.easeOut),
            child: Text(
              widget.data.subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 버블 주변에 떠다니는 작은 ✨ ⭐.
class _BubbleSparkles extends StatelessWidget {
  const _BubbleSparkles({required this.progress});
  final double progress;

  static const _items = <_Sparkle>[
    _Sparkle(emoji: '✨', dx: 0.05, dy: 0.10, size: 22, phase: 0.0),
    _Sparkle(emoji: '⭐', dx: 0.92, dy: 0.18, size: 18, phase: 0.30),
    _Sparkle(emoji: '✨', dx: 0.08, dy: 0.85, size: 16, phase: 0.55),
    _Sparkle(emoji: '⭐', dx: 0.90, dy: 0.80, size: 20, phase: 0.7),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          return Stack(
            children: [
              for (final s in _items)
                Positioned(
                  left: s.dx * w - s.size / 2,
                  top: s.dy * h +
                      math.sin((progress + s.phase) * math.pi * 2) * 6,
                  child: Opacity(
                    opacity: 0.45 +
                        0.35 *
                            math.sin((progress + s.phase) * math.pi * 2),
                    child: Text(s.emoji,
                        style: TextStyle(fontSize: s.size, height: 1)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Sparkle {
  const _Sparkle({
    required this.emoji,
    required this.dx,
    required this.dy,
    required this.size,
    required this.phase,
  });
  final String emoji;
  final double dx;
  final double dy;
  final double size;
  final double phase;
}

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
