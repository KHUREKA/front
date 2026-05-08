import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// "AI가 정해주기" 텍스트 버튼.
///
/// 스와이프 화면 우상단처럼 작게 노출하는 용도.
/// - 누르면 다이얼로그 후 [onConfirm] 호출.
class AiSuggestButton extends StatelessWidget {
  const AiSuggestButton({
    super.key,
    required this.onConfirm,
    this.label = 'AI가 정해주기',
  });

  final VoidCallback onConfirm;
  final String label;

  Future<void> _confirm(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('AI에게 맡길까요?'),
        content: const Text(
          '지금까지 고른 순위는 사라져요.\n괜찮으세요?',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              '아니요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text(
              'AI에게 맡길게요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (ok == true) onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _confirm(context),
      icon: const Icon(Icons.auto_awesome_rounded,
          size: 18, color: AppColors.primary),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          height: 1.2,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
