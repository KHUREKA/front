import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../data/auth_repository.dart';
import '../../data/dto/signup_request.dart';
import 'auth_provider.dart';

part 'signup_provider.freezed.dart';

/// 회원가입 단계별 입력 상태.
///
/// 사용자가 뒤로 갔다 돌아와도 입력값이 유지되도록 모든 단계의 값을 한 곳에 보관.
@freezed
class SignupFormState with _$SignupFormState {
  const SignupFormState._();

  const factory SignupFormState({
    // Step 1
    @Default('') String name,

    // Step 2
    @Default('') String email,
    @Default(false) bool emailCheckLoading,
    @Default(false) bool emailChecked,
    @Default(false) bool emailDuplicate,

    // Step 3
    @Default('') String password,
    @Default('') String passwordConfirm,
    @Default(true) bool obscurePassword,

    // Step 4
    @Default('') String phone,

    // Step 5 — 약관
    @Default(false) bool agreedTerms,
    @Default(false) bool agreedPrivacy,
    @Default(false) bool agreedMarketing,

    // Step 6
    @Default(<String>[]) List<String> selectedGenres,

    // 진행 상태
    @Default(0) int currentStep,
    @Default(false) bool isSubmitting,
    String? submitError,
  }) = _SignupFormState;

  /// 1-indexed (사용자에게 보여줄 때).
  int get displayStep => currentStep + 1;
  int get totalSteps => AppConstants.signupTotalSteps;

  bool get isLastStep => currentStep >= totalSteps - 1;
  bool get isFirstStep => currentStep <= 0;

  /// 전체 동의 여부 (체크박스 표시용).
  bool get allAgreed => agreedTerms && agreedPrivacy && agreedMarketing;

  /// 필수 약관만 동의됐는지 (다음 단계 진행 가능 여부).
  bool get requiredAgreed => agreedTerms && agreedPrivacy;

  /// 현재 단계에서 "다음" 버튼 활성화 여부.
  bool get canProceed {
    switch (currentStep) {
      case 0:
        return Validators.name(name) == null;
      case 1:
        return Validators.email(email) == null &&
            emailChecked &&
            !emailDuplicate;
      case 2:
        return Validators.password(password) == null &&
            password == passwordConfirm;
      case 3:
        // 휴대폰은 선택 — 비어있어도 OK, 입력했다면 형식 맞아야 함
        return phone.isEmpty || Validators.phone(phone) == null;
      case 4:
        return requiredAgreed;
      case 5:
        return selectedGenres.isNotEmpty;
      default:
        return false;
    }
  }
}

/// 회원가입 폼 컨트롤러.
class SignupNotifier extends StateNotifier<SignupFormState> {
  SignupNotifier(this._ref) : super(const SignupFormState());

  final Ref _ref;

  AuthRepository get _repo => _ref.read(authRepositoryProvider);

  // ---- 입력값 변경 ----

  void setName(String value) => state = state.copyWith(name: value);

  void setEmail(String value) {
    // 이메일 변경되면 중복 체크 무효화
    state = state.copyWith(
      email: value,
      emailChecked: false,
      emailDuplicate: false,
    );
  }

  void setPassword(String value) =>
      state = state.copyWith(password: value);

  void setPasswordConfirm(String value) =>
      state = state.copyWith(passwordConfirm: value);

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void setPhone(String value) {
    // 자동 하이픈 적용
    state = state.copyWith(phone: Validators.formatPhone(value));
  }

  // ---- 약관 ----

  void toggleTerms(bool value) =>
      state = state.copyWith(agreedTerms: value);
  void togglePrivacy(bool value) =>
      state = state.copyWith(agreedPrivacy: value);
  void toggleMarketing(bool value) =>
      state = state.copyWith(agreedMarketing: value);

  /// "전체 동의" 토글.
  void toggleAllAgreed(bool value) {
    state = state.copyWith(
      agreedTerms: value,
      agreedPrivacy: value,
      agreedMarketing: value,
    );
  }

  // ---- 장르 ----

  void toggleGenre(String genre) {
    final next = [...state.selectedGenres];
    if (next.contains(genre)) {
      next.remove(genre);
    } else {
      next.add(genre);
    }
    state = state.copyWith(selectedGenres: next);
  }

  // ---- 이메일 중복 확인 ----

  Future<void> checkEmailDuplicate() async {
    if (Validators.email(state.email) != null) return;
    state = state.copyWith(emailCheckLoading: true);
    try {
      final isDup = await _repo.checkEmailDuplicate(state.email.trim());
      state = state.copyWith(
        emailCheckLoading: false,
        emailChecked: true,
        emailDuplicate: isDup,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        emailCheckLoading: false,
        submitError: e.message,
      );
    }
  }

  // ---- 단계 이동 ----

  void nextStep() {
    if (!state.canProceed) return;
    if (state.isLastStep) return;
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void prevStep() {
    if (state.isFirstStep) return;
    state = state.copyWith(currentStep: state.currentStep - 1);
  }

  void goToStep(int step) {
    if (step < 0 || step >= state.totalSteps) return;
    state = state.copyWith(currentStep: step);
  }

  // ---- 가입 완료 ----

  /// 마지막 단계에서 "가입 완료" 호출.
  /// 성공 시 [authProvider] 갱신되며 `true` 반환.
  Future<bool> submit() async {
    if (!state.canProceed) return false;
    state = state.copyWith(isSubmitting: true, submitError: null);
    try {
      final request = SignupRequest(
        name: state.name.trim(),
        email: state.email.trim(),
        password: state.password,
        phone: state.phone.isEmpty ? null : state.phone,
        marketingAgreed: state.agreedMarketing,
        genres: state.selectedGenres,
      );
      final response = await _repo.signup(request);
      await _ref.read(authProvider.notifier).applyAuthResponse(response);
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: '문제가 생겼어요. 잠시 후 다시 시도해주세요.',
      );
      return false;
    }
  }

  /// 회원가입 플로우를 완전히 떠날 때 호출 (입력 초기화).
  void reset() => state = const SignupFormState();
}

/// autoDispose: 회원가입 화면을 떠나면 자동으로 상태 정리.
final signupProvider =
    StateNotifierProvider.autoDispose<SignupNotifier, SignupFormState>(
  (ref) => SignupNotifier(ref),
);
