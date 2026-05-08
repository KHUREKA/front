import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// 발견 플로우 상단의 진행률 바.
///
/// - 4dp 두께
/// - 부드러운 채움 애니메이션 (300ms easeOut)
/// - [step] = 1~[total] (1-indexed)
class DiscoveryProgress extends StatelessWidget {
  const DiscoveryProgress({
    super.key,
    required this.step,
    required this.total,
  });

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = (step / total).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final filled = constraints.maxWidth * ratio;
        return Stack(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: filled,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );
      },
    );
  }
}
