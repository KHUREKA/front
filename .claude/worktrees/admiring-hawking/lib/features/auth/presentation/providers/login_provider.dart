import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/auth_repository.dart';
import 'auth_provider.dart';

part 'login_provider.freezed.dart';

/// 로그인 화면 상태.
@freezed
class LoginFormState with _$LoginFormState {
  const LoginFormState._();

  const factory LoginFormState({
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool obscurePassword,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _LoginFormState;

  /// "로그인" 버튼 활성화 조건.
  bool get canSubmit =>
      email.isNotEmpty && password.isNotEmpty && !isLoading;
}

/// 로그인 폼 컨트롤러.
class LoginNotifier extends StateNotifier<LoginFormState> {
  LoginNotifier(this._ref) : super(const LoginFormState());

  final Ref _ref;

  AuthRepository get _repo => _ref.read(authRepositoryProvider);

  void setEmail(String value) {
    state = state.copyWith(email: value, errorMessage: null);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// 로그인 시도.
  /// 성공 시 [authProvider] 상태가 갱신되며 `true` 반환.
  /// 실패 시 [LoginFormState.errorMessage] 에 한국어 메시지 저장 후 `false` 반환.
  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _repo.login(state.email.trim(), state.password);
      await _ref.read(authProvider.notifier).applyAuthResponse(response);
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '문제가 생겼어요. 잠시 후 다시 시도해주세요.',
      );
      return false;
    }
  }

  /// 화면 떠날 때 입력 정리.
  void reset() {
    state = const LoginFormState();
  }
}

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginFormState>(
  (ref) => LoginNotifier(ref),
);
