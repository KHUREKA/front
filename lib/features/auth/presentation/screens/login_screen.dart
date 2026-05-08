import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/login_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/friendly_error_text.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(loginProvider.notifier).submit();
    if (!mounted) return;
    if (ok) {
      context.go(RouteNames.home);
    }
    // 실패 시 errorMessage가 state에 들어오므로 화면이 자동 갱신됨.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  _Logo(),
                  const SizedBox(height: 16),
                  Text(
                    '환영합니다',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayLarge.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '도담에 오신 것을 환영합니다',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  AuthTextField(
                    label: '이메일',
                    controller: _emailCtrl,
                    hint: 'hong@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: notifier.setEmail,
                  ),
                  const SizedBox(height: 20),

                  AuthTextField(
                    label: '비밀번호',
                    controller: _passwordCtrl,
                    hint: '비밀번호를 입력해주세요',
                    obscureText: state.obscurePassword,
                    onObscureToggle: notifier.toggleObscurePassword,
                    textInputAction: TextInputAction.done,
                    onChanged: notifier.setPassword,
                    onSubmitted: (_) {
                      if (state.canSubmit) _submit();
                    },
                  ),

                  const SizedBox(height: 16),

                  if (state.errorMessage != null)
                    FriendlyErrorText(message: state.errorMessage!),

                  const SizedBox(height: 8),

                  // 비밀번호 찾기
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('비밀번호 찾기는 준비 중이에요.'),
                          ),
                        );
                      },
                      child: const Text('비밀번호를 잊으셨나요?'),
                    ),
                  ),

                  const Spacer(),

                  // 로그인 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.canSubmit ? _submit : null,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('로그인'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 회원가입 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '처음이세요?',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(RouteNames.signup),
                        child: const Text('회원가입하기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/aiIMG.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
