import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 결과를 기다리는 동안 보여주는 친절한 로딩 연출.
///
/// - 코랄 회전 인디케이터
/// - 1초마다 메시지 교체 (총 3개), AnimatedSwitcher 로 페이드/슬라이드
class DiscoveryLoadingScreen extends StatefulWidget {
  const DiscoveryLoadingScreen({super.key});

  @override
  State<DiscoveryLoadingScreen> createState() => _DiscoveryLoadingScreenState();
}

class _DiscoveryLoadingScreenState extends State<DiscoveryLoadingScreen> {
  static const _messages = <String>[
    '조건을 살펴보고 있어요...',
    '딱 맞는 공연을 찾고 있어요 ✨',
    '거의 다 됐어요!',
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _index = (_index + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 32),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Padding(
              key: ValueKey(_index),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _messages[_index],
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
