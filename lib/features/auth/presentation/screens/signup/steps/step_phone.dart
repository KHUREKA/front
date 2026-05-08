import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../providers/signup_provider.dart';
import '../../../widgets/auth_text_field.dart';

class StepPhone extends ConsumerStatefulWidget {
  const StepPhone({super.key});

  @override
  ConsumerState<StepPhone> createState() => _StepPhoneState();
}

class _StepPhoneState extends ConsumerState<StepPhone> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: ref.read(signupProvider).phone);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final formatted = Validators.formatPhone(value);
    if (formatted != _ctrl.text) {
      _ctrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    ref.read(signupProvider.notifier).setPhone(formatted);
  }

  String? _phoneError(String value) {
    if (value.isEmpty) return null;
    return Validators.phone(value);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);

    // AutofillGroup + AutofillHints.telephoneNumber 로 시스템 자동완성 활성화.
    // - Android: Google 계정/IME 에 저장된 번호가 있으면 키보드 위 제안에 표시
    // - iOS: Keychain 저장 번호 + iMessage 인증번호 자동입력 지원
    // - 디바이스 SIM 번호 직접 읽기는 OS 정책상 불가 (특히 iOS 는 절대 불가).
    return AutofillGroup(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('휴대폰 번호', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 8),
            Text(
              '응모 결과 알림에 사용돼요. 입력하지 않아도 괜찮아요.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            AuthTextField(
              label: '휴대폰 번호 (선택)',
              controller: _ctrl,
              hint: '010-1234-5678',
              helperText: '저장된 번호가 있으면 키보드 위에 제안돼요',
              autofocus: true,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                LengthLimitingTextInputFormatter(13),
              ],
              onChanged: _onChanged,
              errorText: _phoneError(state.phone),
            ),
          ],
        ),
      ),
    );
  }
}
