import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';
import 'scrolling_poster_row.dart';

/// 홈 화면의 시그니처 히어로 카드.
///
/// 구성 (z-순):
///   1) 따뜻한 일출 그라데이션 (secondary 옐로 → 코랄 → primaryDark)
///   2) 3줄 무한 스크롤 포스터 (저투명 — 분위기용 텍스처)
///   3) 중앙 카피 + 하단 CTA 버튼 (펄스)
///   4) Material+InkWell 히트 영역 (탭 시 /discovery, 0.98 스케일)
class HeroDiscoveryCard extends ConsumerStatefulWidget {
  const HeroDiscoveryCard({super.key});

  static const double height = 360;
  static const double radius = 24;

  @override
  ConsumerState<HeroDiscoveryCard> createState() =>
      _HeroDiscoveryCardState();
}

class _HeroDiscoveryCardState extends ConsumerState<HeroDiscoveryCard> {
  double _scale = 1.0;

  void _setPressed(bool pressed) {
    if (!mounted) return;
    setState(() => _scale = pressed ? 0.98 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final asyncImages = ref.watch(backgroundPerformancesProvider);

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Container(
        height: HeroDiscoveryCard.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HeroDiscoveryCard.radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.30),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(HeroDiscoveryCard.radius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1) 검정 base
              const ColoredBox(color: Colors.black),

              // 2) 포스터 — 그대로 (오버레이가 톤을 잡아줌)
              asyncImages.when(
                data: (performances) {
                  final urls = performances
                      .map((p) => p.posterImageUrl)
                      .toList(growable: false);
                  if (urls.length < 3) return const SizedBox.shrink();
                  return _PosterRows(imageUrls: urls);
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // 3) 짙은 와인 오버레이 — #260407 @ 70%
              const ColoredBox(color: Color(0xB3260407)),

              // 4) 중앙 카피 + 하단 CTA
              const _Content(),

              // 4) 탭 영역 (최상단)
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => context.push(RouteNames.discovery),
                    onTapDown: (_) => _setPressed(true),
                    onTapUp: (_) => _setPressed(false),
                    onTapCancel: () => _setPressed(false),
                    splashColor: Colors.white.withValues(alpha: 0.18),
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3줄 포스터 띠 — 줄마다 시작 위치/방향/속도가 다르게 분배.
class _PosterRows extends StatelessWidget {
  const _PosterRows({required this.imageUrls});

  final List<String> imageUrls;

  static List<String> _shift(List<String> list, int by) {
    if (list.isEmpty) return list;
    final n = by % list.length;
    return [...list.sublist(n), ...list.sublist(0, n)];
  }

  @override
  Widget build(BuildContext context) {
    final n = imageUrls.length;
    final row1 = imageUrls;
    final row2 = _shift(imageUrls, n ~/ 3);
    final row3 = _shift(imageUrls, (n * 2) ~/ 3);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScrollingPosterRow(
          imageUrls: row1,
          duration: const Duration(seconds: 30),
        ),
        ScrollingPosterRow(
          imageUrls: row2,
          duration: const Duration(seconds: 35),
          reverse: true,
        ),
        ScrollingPosterRow(
          imageUrls: row3,
          duration: const Duration(seconds: 40),
        ),
      ],
    );
  }
}

/// 카드 안 콘텐츠 (헤드라인 + 부제 + CTA).
class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final shadow = Shadow(
      color: Colors.black.withValues(alpha: 0.30),
      blurRadius: 12,
      offset: const Offset(0, 2),
    );

    final headlineStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 34,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.2,
      letterSpacing: -0.6,
      shadows: [shadow],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text('구경 거리', style: headlineStyle),
          Text('찾으러 가기', style: headlineStyle),
          const SizedBox(height: 14),
          Text(
            'AI가 딱 맞는 공연을 찾아드려요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.5,
              shadows: [shadow],
            ),
          ),
          const Spacer(),
          const _CtaPill(),
        ],
      ),
    );
  }
}

/// 클릭을 유도하는 흰색 알약형 CTA. 살짝 펄스 애니메이션.
class _CtaPill extends StatefulWidget {
  const _CtaPill();

  @override
  State<_CtaPill> createState() => _CtaPillState();
}

class _CtaPillState extends State<_CtaPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '함께 찾아볼까요?',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              size: 24,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
