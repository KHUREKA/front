import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// 매수 (본인 포함) 카운터.
///
/// - [-] 56×56dp / 가운데 숫자 32sp / [+] 56×56dp
/// - 1~4 범위. 경계에 도달하면 해당 버튼 비활성화.
class CompanionCounter extends StatelessWidget {
  const CompanionCounter({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.min = 1,
    this.max = 4,
  });

  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final canDec = value > min;
    final canInc = value < max;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundButton(
          icon: Icons.remove_rounded,
          enabled: canDec,
          onTap: canDec ? onDecrement : null,
        ),
        SizedBox(
          width: 100,
          child: Text(
            '$value매',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ),
        _RoundButton(
          icon: Icons.add_rounded,
          enabled: canInc,
          onTap: canInc ? onIncrement : null,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.primary : AppColors.border;
    final iconColor = enabled ? Colors.white : AppColors.textTertiary;

    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, size: 28, color: iconColor),
        ),
      ),
    );
  }
}
