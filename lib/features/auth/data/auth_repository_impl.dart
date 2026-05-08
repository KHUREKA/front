import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/user.dart';
import 'auth_repository.dart';
import 'dto/auth_response.dart';
import 'dto/signup_request.dart';

/// 실제 백엔드 연결 구현.
///
/// 응답 봉투(`{result, data, error}`)는 `DioClient` 의 envelope 인터셉터가
/// 미리 풀어주므로 여기서는 `data` 안쪽 모양만 신경 쓰면 된다.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.dioClient,
    required this.storage,
  });

  final DioClient dioClient;
  final SecureStorage storage;

  Dio get _dio => dioClient.dio;

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        options: Options(extra: const {'skipAuth': true}),
      );
      return AuthResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw AuthException(
        friendlyMessageFromError(e),
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  @override
  Future<AuthResponse> signup(SignupRequest request) async {
    // 백엔드는 회원가입 성공 시 빈 응답(Void)만 내려준다.
    // 토큰을 받으려면 별도로 login 을 한 번 더 호출해야 한다.
    try {
      await _dio.post<void>(
        ApiEndpoints.signup,
        data: request.toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );
      // 회원가입 직후 자동 로그인.
      return login(request.email, request.password);
    } on DioException catch (e) {
      throw AuthException(
        friendlyMessageFromError(e),
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  @override
  Future<bool> checkEmailDuplicate(String email) async {
    // 백엔드 미구현. 회원가입 시 409 로 자연 검증되므로 항상 false 로 통과시킨다.
    return false;
  }

  @override
  Future<void> logout() async {
    // 백엔드 logout 엔드포인트가 없으므로 서버 통지 없이 종료.
    // (로컬 토큰 삭제는 호출자(`AuthNotifier.logout`)가 SecureStorage 로 처리)
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await storage.readAccessToken();
    if (token == null || token.isEmpty) return null;
    try {
      if (JwtDecoder.isExpired(token)) {
        await storage.clearTokens();
        return null;
      }
      final claims = JwtDecoder.decode(token);
      return UserJwt.fromJwtClaims(claims);
    } catch (_) {
      // 토큰 파싱 실패 → 손상된 토큰으로 간주하고 정리.
      await storage.clearTokens();
      return null;
    }
  }
}
