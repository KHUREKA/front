import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// "응모 12회 · 당첨 3회 🎉" 작은 통계 칩.
class StatsChip extends StatelessWidget {
  const StatsChip({
    super.key,
    required this.totalApplications,
    required this.totalWins,
  });

  final int totalApplications;
  final int totalWins;

  @override
  Widget build(BuildContext context) {
    final hasWins = totalWins > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        hasWins
            ? '응모 ${totalApplications}회 · 당첨 ${totalWins}회 🎉'
            : '응모 ${totalApplications}회',
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          height: 1.2,
        ),
      ),
    );
  }
}
