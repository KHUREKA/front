import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

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
/// - 3 탭: 응모내역 / 홈 / 마이
/// - 아이콘 28dp + 라벨 14sp
/// - 어르신 친화: 큰 터치 영역, 선택 상태 명확 (코랄 + 굵은 라벨)
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
      activeIcon: Icons.confirmation_number,
      label: '응모내역',
    ),
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: '홈',
    ),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: '마이',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
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

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.primary : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.activeIcon : item.icon,
                size: 28,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
