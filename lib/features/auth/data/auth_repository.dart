import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user.dart';
import 'dto/auth_response.dart';
import 'dto/signup_request.dart';
import 'mock_auth_repository.dart';

/// 인증 관련 데이터 접근 인터페이스.
///
/// presentation 계층은 이 인터페이스에만 의존한다.
/// 실제 API 호출은 [AuthRepositoryImpl], 개발용 가짜 데이터는
/// [MockAuthRepository]가 담당한다.
abstract class AuthRepository {
  /// 이메일/비밀번호 로그인.
  /// 실패 시 [AuthException] 발생.
  Future<AuthResponse> login(String email, String password);

  /// 회원가입.
  /// 성공 시 자동 로그인된 [AuthResponse] 반환.
  Future<AuthResponse> signup(SignupRequest request);

  /// 이메일 중복 여부.
  /// `true` 면 이미 사용 중인 이메일.
  Future<bool> checkEmailDuplicate(String email);

  /// 서버에 로그아웃 통지 (토큰 무효화).
  /// 토큰 로컬 삭제는 호출자가 SecureStorage로 별도 처리.
  Future<void> logout();

  /// 저장된 토큰으로 현재 사용자 정보 조회.
  /// 로그인 안 된 상태면 `null`.
  Future<User?> getCurrentUser();
}

/// 인증 도메인 예외.
///
/// UI에서 사용자에게 그대로 보여줄 수 있는 한국어 메시지를 [message]에 담는다.
class AuthException implements Exception {
  const AuthException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AuthException($code): $message';
}

/// 앱 전역 [AuthRepository] provider.
///
/// 현재는 [MockAuthRepository] 반환. 서버 연결되면 [AuthRepositoryImpl] 로 교체:
/// ```dart
/// final dio = ref.watch(dioClientProvider);
/// final storage = ref.watch(secureStorageProvider);
/// return AuthRepositoryImpl(dioClient: dio, storage: storage);
/// ```
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
