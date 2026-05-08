import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/performance.dart';
import '../widgets/hero_discovery_card.dart';
import '../widgets/nearby_performance_list.dart';
import '../widgets/recommended_performance_list.dart';

/// 홈 화면.
///
/// 레이아웃 (CustomScrollView + Slivers):
/// 1. 그리팅 (이름 + 위치 칩)
/// 2. HeroDiscoveryCard
/// 3. "내 근처 문화" 섹션 + NearbyPerformanceList (가로 스크롤)
/// 4. "이런 문화도 있어요" 섹션 + RecommendedPerformanceSliverList
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final greetingName = user?.name ?? '회원';

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
            // 1. 그리팅
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '안녕하세요, $greetingName님 👋',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _LocationChip(location: '서울 강남구'),
                  ],
                ),
              ),
            ),

            // 2. Hero Discovery Card
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: HeroDiscoveryCard(),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 32)),

            // 3. 섹션 타이틀 — 내 근처 문화
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _SectionTitle('내 근처 문화'),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 16)),

            // 4. Nearby 가로 스크롤
            SliverToBoxAdapter(
              child: NearbyPerformanceList(
                onTapPerformance: (p) => _showPlaceholderSnack(context, p),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 32)),

            // 5. 섹션 타이틀 — 이런 문화도 있어요
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _SectionTitle('이런 문화도 있어요'),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 16)),

            // 6. Recommended 세로 스택 (Sliver)
            RecommendedPerformanceSliverList(
              onTapPerformance: (p) => _showPlaceholderSnack(context, p),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      );
  }

  void _showPlaceholderSnack(BuildContext context, Performance p) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${p.title}" 상세 화면은 다음 단계에 만들 거예요'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// 우상단 위치 칩.
class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.location});
  final String location;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('위치 변경은 준비 중이에요.')),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📍', style: TextStyle(fontSize: 16, height: 1)),
              const SizedBox(width: 4),
              Text(
                location,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 섹션 제목.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.titleLarge);
  }
}
