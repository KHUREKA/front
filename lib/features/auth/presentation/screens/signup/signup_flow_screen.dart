import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../providers/signup_provider.dart';
import '../../widgets/friendly_error_text.dart';
import '../../widgets/step_progress_bar.dart';
import 'steps/step_email.dart';
import 'steps/step_genre.dart';
import 'steps/step_name.dart';
import 'steps/step_password.dart';
import 'steps/step_phone.dart';
import 'steps/step_terms.dart';

/// 회원가입 6단계 플로우 컨테이너.
///
/// - 상단: AppBar (뒤로가기 = 이전 단계 또는 화면 탈출) + StepProgressBar
/// - 가운데: PageView (스와이프 비활성, currentStep 으로만 제어)
/// - 하단: "다음" / "가입 완료" 버튼 (canProceed 기반 활성화)
class SignupFlowScreen extends ConsumerStatefulWidget {
  const SignupFlowScreen({super.key});

  @override
  ConsumerState<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends ConsumerState<SignupFlowScreen> {
  final _pageController = PageController();

  static const _steps = <Widget>[
    StepName(),
    StepEmail(),
    StepPassword(),
    StepPhone(),
    StepTerms(),
    StepGenre(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final notifier = ref.read(signupProvider.notifier);
    final state = ref.read(signupProvider);
    if (state.isFirstStep) return true;
    notifier.prevStep();
    return false;
  }

  Future<void> _onPrimaryPressed() async {
    final notifier = ref.read(signupProvider.notifier);
    final state = ref.read(signupProvider);
    if (state.isLastStep) {
      final ok = await notifier.submit();
      if (!mounted) return;
      if (ok) {
        context.go(RouteNames.signupComplete);
      }
    } else {
      notifier.nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);

    // currentStep 변화에 PageView 동기화.
    ref.listen<int>(
      signupProvider.select((s) => s.currentStep),
      (prev, next) {
        if (!_pageController.hasClients) return;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      },
    );

    return PopScope(
      canPop: state.isFirstStep,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldExit = await _onWillPop();
              if (shouldExit && mounted) context.pop();
            },
          ),
          title: const Text('회원가입'),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: StepProgressBar(
                  currentStep: state.displayStep,
                  totalSteps: state.totalSteps,
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _steps,
                ),
              ),
              if (state.submitError != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: FriendlyErrorText(message: state.submitError!),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.canProceed && !state.isSubmitting
                        ? _onPrimaryPressed
                        : null,
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(state.isLastStep ? '가입 완료' : '다음'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

