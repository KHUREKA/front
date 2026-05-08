import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/friendly_error_view.dart';
import '../../../applications/presentation/providers/applications_provider.dart';
import '../../../auth/domain/seat_preference.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/mypage_repository.dart';
import '../../domain/user_profile.dart';
import '../providers/profile_provider.dart';

/// 내 정보 — 조회 + 수정.
///
/// 이름·전화번호·좌석 선호도를 편집해 저장하면 백엔드 `PUT /api/v1/mypage/me`.
/// 저장 후엔 [userProfileProvider] 무효화 + [authProvider] 메모리 동기화로
/// 홈 그리팅 등 다른 화면도 즉시 새 값을 보게 한다.
class AccountInfoScreen extends ConsumerWidget {
  const AccountInfoScreen({super.key});

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  String _formatDate(DateTime dt) {
    final wd = _weekdays[dt.weekday - 1];
    return '${dt.year}년 ${dt.month}월 ${dt.day}일 ($wd)';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(userProfileProvider);
    final asyncStats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '내 정보',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: asyncProfile.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => FriendlyErrorView(
            title: '정보를 불러오지 못했어요',
            description: '잠시 후 다시 시도해주세요',
            onRetry: () => ref.invalidate(userProfileProvider),
          ),
          data: (profile) {
            final stats = asyncStats.maybeWhen(
              data: (s) => '${s.totalApplications}회',
              orElse: () => '...',
            );
            return _EditForm(
              profile: profile,
              joinedAtLabel: _formatDate(profile.joinedAt),
              applicationCountLabel: stats,
            );
          },
        ),
      ),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({
    required this.profile,
    required this.joinedAtLabel,
    required this.applicationCountLabel,
  });

  final UserProfile profile;
  final String joinedAtLabel;
  final String applicationCountLabel;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late SeatPreference? _seatPreference;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController =
        TextEditingController(text: widget.profile.phone ?? '');
    _seatPreference = widget.profile.seatPreference;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name != widget.profile.name) return true;
    if (phone != (widget.profile.phone ?? '')) return true;
    if (_seatPreference != widget.profile.seatPreference) return true;
    return false;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isDirty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('변경된 내용이 없어요.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final newName = _nameController.text.trim();
      final newPhone = _phoneController.text.trim();

      await ref.read(mypageRepositoryProvider).updateProfile(
            username: newName != widget.profile.name ? newName : null,
            phone: newPhone != (widget.profile.phone ?? '') ? newPhone : null,
            seatPreference: _seatPreference != widget.profile.seatPreference
                ? _seatPreference
                : null,
          );

      // 다른 화면(홈 그리팅 등) 즉시 갱신.
      ref.invalidate(userProfileProvider);
      ref.read(authProvider.notifier).syncProfileFields(
            name: newName,
            phone: newPhone.isEmpty ? null : newPhone,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장됐어요.')),
      );
      context.pop();
    } on MyPageException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      setState(() => _saving = false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('잠시 후 다시 시도해주세요.')),
      );
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          _SectionLabel(label: '이름'),
          _EditField(
            controller: _nameController,
            hint: '성함을 입력해주세요',
            validator: (v) {
              final t = v?.trim() ?? '';
              if (t.isEmpty) return '이름을 입력해주세요.';
              if (t.length < 2) return '두 글자 이상 입력해주세요.';
              return null;
            },
          ),

          _SectionLabel(label: '이메일'),
          _LockedRow(value: widget.profile.email),

          _SectionLabel(label: '휴대폰'),
          _EditField(
            controller: _phoneController,
            hint: '010-0000-0000',
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            ],
            validator: (v) {
              final t = v?.trim() ?? '';
              if (t.isEmpty) return null; // 휴대폰은 선택
              return Validators.phone(t);
            },
          ),

          _SectionLabel(label: '편한 자리'),
          _SeatPreferencePicker(
            selected: _seatPreference,
            onChanged: (v) => setState(() => _seatPreference = v),
          ),

          _SectionLabel(label: '가입 정보'),
          _ReadOnlyRow(label: '가입일', value: widget.joinedAtLabel),
          _ReadOnlyRow(label: '가입 후 응모', value: widget.applicationCountLabel),

          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text('저장하기'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: AppTextStyles.bodyLarge.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _LockedRow extends StatelessWidget {
  const _LockedRow({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Icon(Icons.lock_outline_rounded,
              size: 18, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatPreferencePicker extends StatelessWidget {
  const _SeatPreferencePicker({
    required this.selected,
    required this.onChanged,
  });

  final SeatPreference? selected;
  final ValueChanged<SeatPreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final option in SeatPreference.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onChanged(option),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected == option
                        ? AppColors.primary
                        : Colors.transparent,
                    width: selected == option ? 2 : 0,
                  ),
                ),
                child: Row(
                  children: [
                    Text(option.emoji,
                        style: const TextStyle(fontSize: 24, height: 1)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.label,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (selected == option)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
