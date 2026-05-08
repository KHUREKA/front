import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../providers/signup_provider.dart';
import '../../../widgets/auth_text_field.dart';

class StepPassword extends ConsumerStatefulWidget {
  const StepPassword({super.key});

  @override
  ConsumerState<StepPassword> createState() => _StepPasswordState();
}

class _StepPasswordState extends ConsumerState<StepPassword> {
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmCtrl;

  @override
  void initState() {
    super.initState();
    final state = ref.read(signupProvider);
    _passwordCtrl = TextEditingController(text: state.password);
    _confirmCtrl = TextEditingController(text: state.passwordConfirm);
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _passwordError(String value) {
    if (value.isEmpty) return null;
    return Validators.password(value);
  }

  String? _confirmError(String value, String original) {
    if (value.isEmpty) return null;
    if (value != original) return '비밀번호가 서로 달라요. 다시 확인해주세요';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('비밀번호를 만들어주세요', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '영문과 숫자를 포함해 8자 이상으로 만들어주세요.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          AuthTextField(
            label: '비밀번호',
            controller: _passwordCtrl,
            hint: '비밀번호',
            helperText: '영문 + 숫자 포함, 8자 이상',
            autofocus: true,
            obscureText: state.obscurePassword,
            onObscureToggle: notifier.toggleObscurePassword,
            textInputAction: TextInputAction.next,
            onChanged: notifier.setPassword,
            errorText: _passwordError(state.password),
          ),
          const SizedBox(height: 20),
          AuthTextField(
            label: '비밀번호 확인',
            controller: _confirmCtrl,
            hint: '비밀번호를 한 번 더 입력해주세요',
            obscureText: state.obscurePassword,
            textInputAction: TextInputAction.done,
            onChanged: notifier.setPasswordConfirm,
            errorText: _confirmError(state.passwordConfirm, state.password),
          ),
        ],
      ),
    );
  }
}
