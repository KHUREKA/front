import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/discovery_filter_provider.dart';
import '../widgets/discovery_progress.dart';
import 'steps/step_genre.dart';
import 'steps/step_keyword.dart';
import 'steps/step_when.dart';

/// 발견 플로우 컨테이너.
///
/// - Q1 → Q2 → Q3 PageView (가로 스와이프 비활성)
/// - 상단: X 버튼 + 진행률 바
/// - 뒤로가기: 이전 step. Q1 에서는 X 와 동일 (확인 다이얼로그).
class DiscoveryFlowScreen extends ConsumerStatefulWidget {
  const DiscoveryFlowScreen({super.key});

  @override
  ConsumerState<DiscoveryFlowScreen> createState() =>
      _DiscoveryFlowScreenState();
}

class _DiscoveryFlowScreenState extends ConsumerState<DiscoveryFlowScreen> {
  static const _totalSteps = 3;

  late final PageController _pageController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // 새 플로우 진입 시 필터 초기화.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(discoveryFilterProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step < 0 || step >= _totalSteps) return;
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _next() => _goToStep(_currentStep + 1);

  void _completeFlow() {
    // Q3 마치면 결과 화면으로.
    context.go(RouteNames.discoveryResult);
  }

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('정말 그만하시겠어요?'),
        content: const Text(
          '입력하신 내용이 사라져요.',
          style: TextStyle(fontSize: 16),
        ),
        // 색이 비슷하면 헷갈리므로 형태로 위계 분리.
        // OverflowBar 폭 초과로 세로로 떨어지지 않도록 단일 Row 로 강제.
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
                child: const Text(
                  '그만할게요',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 4),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '계속할게요',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _exitToHome() async {
    final ok = await _confirmExit();
    if (!mounted || !ok) return;
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_currentStep == 0) {
          await _exitToHome();
        } else {
          _goToStep(_currentStep - 1);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // 상단: X + 진행률
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _exitToHome,
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                      tooltip: '닫기',
                    ),
                    Expanded(
                      child: DiscoveryProgress(
                        step: _currentStep + 1,
                        total: _totalSteps,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_currentStep + 1} / $_totalSteps',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      child: StepGenre(onNext: _next),
                    ),
                    StepKeyword(onNext: _next, onSkip: _next),
                    SingleChildScrollView(
                      child: StepWhen(onComplete: _completeFlow),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
