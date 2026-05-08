import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// 마이페이지 설정 섹션 컨테이너.
///
/// 흰 배경 + 16px 라운드 + 옅은 그림자, 자식 사이 1px 디바이더.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: _withDividers(children),
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) {
        out.add(
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color(0xFFF5F5F5),
          ),
        );
      }
    }
    return out;
  }
}
