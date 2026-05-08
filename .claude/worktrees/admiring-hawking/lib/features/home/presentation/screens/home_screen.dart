import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../mypage/presentation/providers/profile_provider.dart';
import '../providers/home_provider.dart';
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
    // 이름은 마이페이지 프로필(/mypage/me)을 우선 사용 — 사용자가 정보 수정 시 즉시 반영.
    // 프로필 로딩 중/에러일 땐 JWT 디코드 결과(authProvider)로 폴백.
    final asyncProfile = ref.watch(userProfileProvider);
    final user = ref.watch(authProvider).user;
    final greetingName = asyncProfile.maybeWhen(
      data: (p) => p.name.isNotEmpty ? p.name : (user?.name ?? '회원'),
      orElse: () => user?.name ?? '회원',
    );

    // 홈 카드 이미지를 미리 디코드/캐시 — 첫 진입 시 cached_network_image
    // 의 race로 빈 이미지가 보이는 문제 회피. 데이터가 도착할 때마다
    // 카드가 그려지기 전에 thumbnail 들을 워밍업한다.
    ref.listen(homeEventsProvider, (_, next) {
      next.whenData((data) {
        for (final e in [...data.nearbyEvents, ...data.recommendedEvents]) {
          final url = e.thumbnailUrl;
          if (url != null && url.isNotEmpty) {
            precacheImage(CachedNetworkImageProvider(url), context);
          }
        }
      });
    });

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
                        '안녕하세요, $greetingName님!',
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
                    const _NotificationBell(),
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
                onTapPerformance: (p) =>
                    context.push(RouteNames.eventDetailFor(p.id)),
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
              onTapPerformance: (p) =>
                  context.push(RouteNames.eventDetailFor(p.id)),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      );
  }
}

/// 우상단 알림 종 — 향후 알림 센터 진입점.
class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('알림 기능은 준비 중이에요.')),
          );
        },
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: 24,
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
