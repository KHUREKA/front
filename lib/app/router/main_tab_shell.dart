import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/main_bottom_navigation.dart';

/// `StatefulShellRoute.indexedStack` 의 builder 가 사용하는 셸.
///
/// 3개 탭(응모내역/홈/마이) 의 본문을 [navigationShell] 로 받아
/// 동일한 Scaffold + 하단 네비를 공유한다.
///
/// 각 브랜치는 IndexedStack 내부에서 살아있어 **스크롤 위치/스테이트가 보존**된다.
/// 같은 탭을 다시 누르면 해당 탭의 라우트 스택을 초기 위치로 reset.
class MainTabShell extends StatelessWidget {
  const MainTabShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: MainBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onIndexChanged: (i) => navigationShell.goBranch(
          i,
          // 같은 탭을 다시 탭하면 그 브랜치의 첫 라우트로 reset.
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
