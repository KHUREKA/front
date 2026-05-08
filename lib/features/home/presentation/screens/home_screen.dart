import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/main_bottom_navigation.dart';
import '../../../../shared/widgets/main_tab_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/hero_discovery_card.dart';

/// 홈 화면.
///
/// 레이아웃 (CustomScrollView + Slivers):
/// 1. 그리팅 영역 (이름 + 위치 칩)
/// 2. HeroDiscoveryCard — 다음 단계에서 구현 (현재 placeholder)
/// 3. "내 근처 문화" 섹션 + 가로 스크롤 리스트 (placeholder)
/// 4. "이런 문화도 있어요" 섹션 + 세로 카드 리스트 (placeholder)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final greetingName = user?.name ?? '회원';

    return MainTabScaffold(
      currentTab: MainTab.home,
      backgroundColor: AppColors.background,
      body: SafeArea(
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

            // 3. 섹션 타이틀
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _SectionTitle('내 근처 문화'),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 16)),

            // 4. Nearby 가로 스크롤 (다음 단계)
            const SliverToBoxAdapter(child: _NearbyPlaceholder()),

            const SliverPadding(padding: EdgeInsets.only(top: 32)),

            // 5. 섹션 타이틀
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _SectionTitle('이런 문화도 있어요'),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 16)),

            // 6. Recommended 세로 카드 (다음 단계, placeholder 3개)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: _RecommendedPlaceholder(),
                ),
                childCount: 3,
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
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

// ============================================================
// 아래 placeholder 들은 4-B 단계에서 실제 위젯으로 교체된다.
// ============================================================

class _NearbyPlaceholder extends StatelessWidget {
  const _NearbyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Container(
          width: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            '근처 공연\n카드',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendedPlaceholder extends StatelessWidget {
  const _RecommendedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        '추천 공연 카드 (다음 단계)',
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
