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

    return SingleChildScrollView(
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
            helperText: '예: 010-1234-5678',
            autofocus: true,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
              LengthLimitingTextInputFormatter(13),
            ],
            onChanged: _onChanged,
            errorText: _phoneError(state.phone),
          ),
        ],
      ),
    );
  }
}
