import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'settings_tile.dart';

/// 토글 스위치가 우측에 있는 [SettingsTile].
///
/// - 어르신 친화: 토글 60×32dp (기본보다 큼)
/// - 줄 전체 탭으로도 토글 가능
class SettingsToggleTile extends StatelessWidget {
  const SettingsToggleTile({
    super.key,
    this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData? icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      label: label,
      subtitle: subtitle,
      onTap: () => onChanged(!value),
      trailing: _BigSwitch(value: value, onChanged: onChanged),
    );
  }
}

/// 60×32dp 큰 스위치.
///
/// Material 의 Switch 는 모바일에서 작아 보일 수 있어 직접 그림.
class _BigSwitch extends StatelessWidget {
  const _BigSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 60,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? AppColors.primary : const Color(0xFFD0D0D0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
