import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 어르신용 큰 입력창.
///
/// 레이아웃:
/// - 위: 18sp 굵은 라벨 ("이메일을 알려주세요")
/// - 가운데: 64dp 입력창, 내부 폰트 20sp
/// - 아래: 14sp 회색 도움말 또는 빨간 에러 메시지
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.onObscureToggle,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.autofocus = false,
    this.suffix,
    this.maxLength,
  }) : assert(
          controller == null || initialValue == null,
          'controller와 initialValue는 동시에 줄 수 없어요',
        );

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool obscureText;

  /// 눈 아이콘으로 obscureText 토글하고 싶을 때 콜백 제공.
  final VoidCallback? onObscureToggle;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool autofocus;

  /// onObscureToggle이 없을 때 우측에 표시할 임의 위젯.
  final Widget? suffix;

  final int? maxLength;

  static const TextStyle _inputStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    Widget? effectiveSuffix = suffix;
    if (onObscureToggle != null) {
      effectiveSuffix = IconButton(
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 28,
        ),
        color: AppColors.textSecondary,
        tooltip: obscureText ? '비밀번호 보기' : '비밀번호 숨기기',
        onPressed: onObscureToggle,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          enabled: enabled,
          autofocus: autofocus,
          autocorrect: !obscureText,
          enableSuggestions: !obscureText,
          style: _inputStyle,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            errorText: hasError ? errorText : null,
            suffixIcon: effectiveSuffix,
          ),
        ),
        if (helperText != null && helperText!.isNotEmpty && !hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              helperText!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
