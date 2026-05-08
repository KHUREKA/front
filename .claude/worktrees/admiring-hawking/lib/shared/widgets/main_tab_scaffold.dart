import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import 'main_bottom_navigation.dart';

/// 메인 탭 3개(응모내역/홈/마이)를 공유하는 Scaffold 래퍼.
///
/// 각 탭 화면은 [body] 만 만들고 이 위젯으로 감싸면 동일한 하단 네비를 얻는다.
///
/// 4-C 단계에서 [StatefulShellRoute] 로 리팩토링해 탭별 내비게이션 스택을 보존할 예정.
/// 지금은 단순 `context.go` 기반 — 탭 전환 시 화면 전체가 새로 빌드된다.
class MainTabScaffold extends StatelessWidget {
  const MainTabScaffold({
    super.key,
    required this.currentTab,
    required this.body,
    this.backgroundColor,
  });

  final MainTab currentTab;
  final Widget body;
  final Color? backgroundColor;

  static const Map<MainTab, String> _routeFor = {
    MainTab.lottery: RouteNames.lottery,
    MainTab.home: RouteNames.home,
    MainTab.mypage: RouteNames.mypage,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
      bottomNavigationBar: MainBottomNavigation(
        currentIndex: currentTab.index,
        onIndexChanged: (i) {
          final tab = MainTab.values[i];
          if (tab == currentTab) return;
          context.go(_routeFor[tab]!);
        },
      ),
    );
  }
}
