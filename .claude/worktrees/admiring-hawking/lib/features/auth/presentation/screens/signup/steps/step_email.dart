import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../providers/signup_provider.dart';
import '../../../widgets/auth_text_field.dart';

class StepEmail extends ConsumerStatefulWidget {
  const StepEmail({super.key});

  @override
  ConsumerState<StepEmail> createState() => _StepEmailState();
}

class _StepEmailState extends ConsumerState<StepEmail> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: ref.read(signupProvider).email);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String? _emailError(String value) {
    if (value.isEmpty) return null;
    return Validators.email(value);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);

    final isValidFormat = Validators.email(state.email) == null;
    final canCheck = isValidFormat && !state.emailCheckLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('이메일을 알려주세요', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '로그인할 때 사용하는 아이디예요.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          AuthTextField(
            label: '이메일',
            controller: _ctrl,
            hint: 'hong@gmail.com',
            helperText: '예: hong@gmail.com',
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: notifier.setEmail,
            errorText: _emailError(state.email),
          ),
          const SizedBox(height: 16),

          // 중복 확인 버튼
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: canCheck ? notifier.checkEmailDuplicate : null,
              child: state.emailCheckLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Text('이메일 중복 확인'),
            ),
          ),

          const SizedBox(height: 16),

          // 결과 메시지
          if (state.emailChecked)
            _CheckResult(isDuplicate: state.emailDuplicate),
        ],
      ),
    );
  }
}

class _CheckResult extends StatelessWidget {
  const _CheckResult({required this.isDuplicate});
  final bool isDuplicate;

  @override
  Widget build(BuildContext context) {
    final color = isDuplicate ? AppColors.error : AppColors.success;
    final icon = isDuplicate ? Icons.error_outline : Icons.check_circle_outline;
    final message = isDuplicate
        ? '이미 사용 중인 이메일이에요. 다른 이메일을 입력해주세요.'
        : '사용할 수 있는 이메일이에요.';

    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: color,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
