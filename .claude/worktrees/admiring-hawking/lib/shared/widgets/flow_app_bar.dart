import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/discovery/presentation/widgets/discovery_progress.dart';

/// 다단계 플로우 공통 상단 헤더.
///
/// 좌측 뒤로가기 ◀ — 진행률 바 — 우측 닫기 ✕ 구성을 제공해
/// 좌석/발견 등 모든 wizard 플로우에서 동일한 모양을 갖도록 한다.
///
/// - [step]: 현재 단계 (1-indexed)
/// - [total]: 전체 단계 수
/// - [onBack]: 좌측 뒤로가기 콜백 (이전 단계)
/// - [onClose]: 우측 닫기 콜백 (플로우 이탈)
/// - [showBack]: 좌측 뒤로가기 버튼 노출 여부 (기본 true)
class FlowAppBar extends StatelessWidget {
  const FlowAppBar({
    super.key,
    required this.step,
    required this.total,
    required this.onBack,
    required this.onClose,
    this.showBack = true,
  });

  final int step;
  final int total;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 28,
                color: AppColors.textPrimary,
              ),
              tooltip: '뒤로',
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: DiscoveryProgress(
              step: step,
              total: total,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$step / $total',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.close_rounded,
              size: 28,
              color: AppColors.textPrimary,
            ),
            tooltip: '닫기',
          ),
        ],
      ),
    );
  }
}
