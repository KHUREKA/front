import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../providers/signup_provider.dart';
import '../../../widgets/auth_text_field.dart';

class StepName extends ConsumerStatefulWidget {
  const StepName({super.key});

  @override
  ConsumerState<StepName> createState() => _StepNameState();
}

class _StepNameState extends ConsumerState<StepName> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: ref.read(signupProvider).name);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String? _nameError(String value) {
    if (value.isEmpty) return null;
    return Validators.name(value);
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
          Text('이름이 어떻게 되세요?', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '본명으로 입력해주세요.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF717171),
            ),
          ),
          const SizedBox(height: 32),
          AuthTextField(
            label: '이름',
            controller: _ctrl,
            hint: '홍길동',
            autofocus: true,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            onChanged: notifier.setName,
            errorText: _nameError(state.name),
            maxLength: 20,
          ),
        ],
      ),
    );
  }
}
