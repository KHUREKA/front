import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 메인 탭 식별자.
///
/// 순서가 곧 [MainBottomNavigation] 의 인덱스와 일치한다.
enum MainTab {
  lottery, // 응모내역
  home, // 홈
  mypage, // 마이
}

extension MainTabX on MainTab {
  int get index {
    switch (this) {
      case MainTab.lottery:
        return 0;
      case MainTab.home:
        return 1;
      case MainTab.mypage:
        return 2;
    }
  }
}

/// 하단 메인 네비게이션.
///
/// 디자인:
/// - 흰 배경 + 위쪽 부드러운 그림자 (날카로운 border 대신)
/// - 선택된 탭의 아이콘 뒤에 코랄 알약(pill) 인디케이터 — width / 색상 애니메이션
/// - 아이콘 교체는 [AnimatedSwitcher] 로 페이드, 라벨은 [AnimatedDefaultTextStyle] 로
///   색·굵기 트윈
/// - 어르신 친화: 큰 터치 영역, 굵은 활성 라벨, 라벨 항상 표시 (아이콘만으로 안 의존)
class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  static const List<_NavItem> _items = [
    _NavItem(
      icon: Icons.confirmation_number_outlined,
      activeIcon: Icons.confirmation_number_rounded,
      label: '응모내역',
    ),
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: '홈',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: '마이',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavTab(
                    item: _items[i],
                    selected: i == currentIndex,
                    onTap: () => onIndexChanged(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  static const _animDuration = Duration(milliseconds: 240);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.10),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 활성 알약 인디케이터.
              AnimatedContainer(
                duration: _animDuration,
                curve: _curve,
                width: selected ? 60 : 40,
                height: 32,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: Icon(
                      selected ? item.activeIcon : item.icon,
                      key: ValueKey<bool>(selected),
                      size: 26,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: _animDuration,
                curve: _curve,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  height: 1.2,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
