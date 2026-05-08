import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../providers/signup_provider.dart';

class StepTerms extends ConsumerWidget {
  const StepTerms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('약관에 동의해주세요', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '서비스를 이용하려면 필수 항목에 동의해주세요.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // 전체 동의
          _AllAgreeRow(
            checked: state.allAgreed,
            onChanged: notifier.toggleAllAgreed,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          _TermRow(
            label: '서비스 이용약관 보기',
            required: true,
            checked: state.agreedTerms,
            onChanged: notifier.toggleTerms,
            onView: () => _showTerms(
              context,
              title: '서비스 이용약관',
              body: _placeholderTerms,
            ),
          ),
          _TermRow(
            label: '개인정보 처리방침 보기',
            required: true,
            checked: state.agreedPrivacy,
            onChanged: notifier.togglePrivacy,
            onView: () => _showTerms(
              context,
              title: '개인정보 처리방침',
              body: _placeholderPrivacy,
            ),
          ),
          _TermRow(
            label: '마케팅 정보 수신 동의',
            required: false,
            checked: state.agreedMarketing,
            onChanged: notifier.toggleMarketing,
            onView: () => _showTerms(
              context,
              title: '마케팅 정보 수신',
              body: _placeholderMarketing,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTerms(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Text(body, style: AppTextStyles.bodyLarge),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('확인'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AllAgreeRow extends StatelessWidget {
  const _AllAgreeRow({required this.checked, required this.onChanged});
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _BigCheckbox(value: checked, onChanged: onChanged, size: 32),
            const SizedBox(width: 16),
            Text(
              '전체 동의하기',
              style: AppTextStyles.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _TermRow extends StatelessWidget {
  const _TermRow({
    required this.label,
    required this.required,
    required this.checked,
    required this.onChanged,
    required this.onView,
  });

  final String label;
  final bool required;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _BigCheckbox(value: checked, onChanged: onChanged, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Text(
                    required ? '[필수] ' : '[선택] ',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: required
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      label,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onView,
              icon: const Icon(Icons.chevron_right, size: 28),
              color: AppColors.textSecondary,
              tooltip: '$label 자세히 보기',
            ),
          ],
        ),
      ),
    );
  }
}

class _BigCheckbox extends StatelessWidget {
  const _BigCheckbox({
    required this.value,
    required this.onChanged,
    required this.size,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: value ? AppColors.primary : AppColors.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: value
            ? Icon(Icons.check, color: Colors.white, size: size * 0.7)
            : null,
      ),
    );
  }
}

const String _placeholderTerms = '''제1조 (목적)
이 약관은 두근티켓이 제공하는 서비스의 이용 조건과 절차, 회원과 회사의 권리·의무 및 책임 사항을 규정함을 목적으로 합니다.

제2조 (정의)
"서비스"란 두근티켓이 제공하는 공연 티켓 응모 및 관련 서비스 일체를 말합니다.

제3조 (회원가입)
회원이 되고자 하는 자는 본 약관에 동의한 후, 회사가 정한 가입 양식에 정보를 기입하여 회원가입을 신청합니다.

(이하 생략 — 실제 약관 전문은 추후 등록됩니다.)
''';

const String _placeholderPrivacy = '''두근티켓은 이용자의 개인정보를 소중히 다룹니다.

1. 수집하는 개인정보 항목
- 필수: 이메일, 이름, 비밀번호
- 선택: 휴대폰 번호, 관심 장르

2. 개인정보의 수집 및 이용 목적
- 회원 식별 및 본인 확인
- 응모 결과 안내
- 서비스 개선

3. 개인정보 보유 기간
회원 탈퇴 시 즉시 파기됩니다.

(이하 생략 — 실제 처리방침 전문은 추후 등록됩니다.)
''';

const String _placeholderMarketing = '''마케팅 정보 수신 동의는 선택 사항입니다.

동의 시 다음과 같은 정보를 받으실 수 있어요:
- 신규 공연 안내
- 할인 쿠폰 및 프로모션
- 맞춤형 공연 추천

동의를 거부하셔도 두근티켓 서비스를 이용하시는 데에는 문제가 없습니다.
언제든지 마이페이지에서 동의를 철회하실 수 있어요.
''';
