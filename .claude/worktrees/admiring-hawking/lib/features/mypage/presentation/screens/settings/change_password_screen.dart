import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/validators.dart';
import '../../../data/mypage_repository.dart';

/// 비밀번호 변경.
///
/// 검증:
/// - 현재 비번 빈 값
/// - 새 비번 8자 이상 + 영문 + 숫자
/// - 새 비번 == 확인
/// - 현재 비번과 새 비번 다름
/// - Mock: 'wrongpw' 입력 시 서버 에러
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _oldError;
  String? _newError;
  String? _confirmError;

  bool _submitting = false;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final oldPw = _oldCtrl.text;
    final newPw = _newCtrl.text;
    final confirm = _confirmCtrl.text;

    setState(() {
      _oldError = oldPw.isEmpty ? '현재 비밀번호를 입력해주세요' : null;
      _newError = Validators.password(newPw);
      _confirmError = Validators.passwordConfirm(newPw, confirm);
      if (_newError == null && oldPw == newPw) {
        _newError = '현재 비밀번호와 다른 비밀번호를 입력해주세요';
      }
    });
    if (_oldError != null || _newError != null || _confirmError != null) {
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref
          .read(mypageRepositoryProvider)
          .changePassword(oldPw: oldPw, newPw: newPw);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 변경되었어요')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        // 서버 에러를 oldError 자리에 친절히 표시.
        _oldError = e is MyPageException ? e.message : '문제가 생겼어요. 다시 시도해주세요';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          '비밀번호 변경',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _PasswordField(
                      label: '현재 비밀번호',
                      controller: _oldCtrl,
                      obscure: _obscureOld,
                      onToggle: () =>
                          setState(() => _obscureOld = !_obscureOld),
                      errorText: _oldError,
                    ),
                    const SizedBox(height: 16),
                    _PasswordField(
                      label: '새 비밀번호',
                      controller: _newCtrl,
                      obscure: _obscureNew,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      errorText: _newError,
                      helper: '영문과 숫자를 포함해 8자 이상',
                    ),
                    const SizedBox(height: 16),
                    _PasswordField(
                      label: '새 비밀번호 확인',
                      controller: _confirmCtrl,
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      errorText: _confirmError,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.border,
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
                  child: _submitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('변경하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.errorText,
    this.helper,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String? errorText;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 64,
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 22,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              color: AppColors.error,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ] else if (helper != null) ...[
          const SizedBox(height: 6),
          Text(
            helper!,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
