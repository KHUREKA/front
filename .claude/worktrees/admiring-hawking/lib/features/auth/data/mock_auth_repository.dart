import '../domain/user.dart';
import 'auth_repository.dart';
import 'dto/auth_response.dart';
import 'dto/signup_request.dart';

/// 개발/테스트용 Mock 구현.
///
/// 실제 서버 연결 전 UI 동작을 검증하기 위한 가짜 데이터.
/// - login: 1초 딜레이 후 가짜 토큰. 이메일에 'fail' 포함 시 에러.
/// - signup: 1.5초 딜레이 후 성공 (해당 정보로 User 생성).
/// - checkEmailDuplicate: 'test@test.com' 만 중복으로 판정.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository();

  // 메모리에 보관하는 "현재 로그인된 사용자". 실제 구현에서는 토큰으로 서버 조회.
  User? _currentUser;

  @override
  Future<AuthResponse> login(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (email.contains('fail')) {
      throw const AuthException(
        '이메일 또는 비밀번호를 다시 확인해주세요.',
        code: 'invalid_credentials',
      );
    }

    final user = User(
      id: 'mock-user-${email.hashCode.abs()}',
      email: email,
      name: _nameFromEmail(email),
      phone: null,
      genres: const ['뮤지컬', '트로트'],
    );
    _currentUser = user;

    return AuthResponse(
      accessToken: _fakeToken(email, kind: 'access'),
    );
  }

  @override
  Future<AuthResponse> signup(SignupRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    final user = User(
      id: 'mock-user-${request.email.hashCode.abs()}',
      email: request.email,
      name: request.username,
      phone: request.phone,
    );
    _currentUser = user;

    return AuthResponse(
      accessToken: _fakeToken(request.email, kind: 'access'),
    );
  }

  @override
  Future<bool> checkEmailDuplicate(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return email.toLowerCase() == 'test@test.com';
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }

  // --- helpers ---

  String _fakeToken(String email, {required String kind}) {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return 'mock.$kind.${email.hashCode.abs()}.$stamp';
  }

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return '회원';
    return local.length >= 2 ? local : '회원';
  }
}
