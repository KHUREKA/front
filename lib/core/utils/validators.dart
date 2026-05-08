/// 입력값 검증 유틸.
///
/// 모든 검증 함수는 다음 규칙을 따른다:
/// - 검증 통과 시 `null` 반환
/// - 실패 시 **어르신이 이해하기 쉬운 한국어 메시지** 반환
///
/// 메시지는 `TextFormField.validator` 또는 직접 표시용으로 모두 사용 가능.
class Validators {
  Validators._();

  // ---------- Email ----------

  /// 단순하고 관대한 이메일 정규식. 일반적인 형식만 거른다.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// 이메일 형식 검증.
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '이메일을 입력해주세요';
    if (!_emailRegex.hasMatch(v)) {
      return '이메일 주소를 다시 확인해주세요 (예: hong@gmail.com)';
    }
    return null;
  }

  // ---------- Password ----------

  static final RegExp _hasLetter = RegExp(r'[a-zA-Z]');
  static final RegExp _hasDigit = RegExp(r'\d');

  /// 비밀번호: 8자 이상, 영문+숫자 포함.
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return '비밀번호를 입력해주세요';
    if (v.length < 8 ||
        !_hasLetter.hasMatch(v) ||
        !_hasDigit.hasMatch(v)) {
      return '비밀번호는 영문과 숫자를 포함해 8자 이상으로 만들어주세요';
    }
    return null;
  }

  /// 비밀번호 확인 (원본과 일치 여부).
  static String? passwordConfirm(String? value, String original) {
    final v = value ?? '';
    if (v.isEmpty) return '비밀번호를 한 번 더 입력해주세요';
    if (v != original) return '비밀번호가 서로 달라요. 다시 확인해주세요';
    return null;
  }

  // ---------- Name ----------

  /// 이름: 2자 이상.
  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '이름을 입력해주세요';
    if (v.length < 2) return '이름은 2자 이상 입력해주세요';
    return null;
  }

  // ---------- Phone ----------

  /// 010-XXXX-XXXX 형식 (자동 하이픈된 입력 기준).
  static final RegExp _phoneRegex = RegExp(r'^010-\d{4}-\d{4}$');

  /// 휴대폰 번호 검증.
  /// 회원가입에서는 선택 입력이므로 빈 문자열은 통과(`null`).
  /// 호출하는 쪽에서 빈값 처리는 별도로 결정.
  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (!_phoneRegex.hasMatch(v)) {
      return '휴대폰 번호를 다시 확인해주세요 (예: 010-1234-5678)';
    }
    return null;
  }

  /// 입력 문자열에 자동으로 하이픈을 넣어 010-XXXX-XXXX 형식으로 변환.
  ///
  /// 숫자가 아닌 문자는 모두 제거. 11자리 초과 시 잘라낸다.
  /// - 0~3자리: `010`
  /// - 4~7자리: `010-1234`
  /// - 8~11자리: `010-1234-5678`
  static String formatPhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final trimmed = digits.length > 11 ? digits.substring(0, 11) : digits;

    if (trimmed.length < 4) return trimmed;
    if (trimmed.length < 8) {
      return '${trimmed.substring(0, 3)}-${trimmed.substring(3)}';
    }
    return '${trimmed.substring(0, 3)}-'
        '${trimmed.substring(3, 7)}-'
        '${trimmed.substring(7)}';
  }
}
