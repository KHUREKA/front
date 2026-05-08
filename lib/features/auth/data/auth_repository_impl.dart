import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/user.dart';
import 'auth_repository.dart';
import 'dto/auth_response.dart';
import 'dto/login_request.dart';
import 'dto/signup_request.dart';

/// 실제 백엔드 연결 구현.
///
/// 현재는 [MockAuthRepository]를 사용 중이며, 서버가 준비되면
/// `authRepositoryProvider`를 이 클래스로 바꾸면 된다.
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
        data: LoginRequest(email: email, password: password).toJson(),
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
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.signup,
        data: request.toJson(),
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
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiEndpoints.signup}/check-email',
        queryParameters: {'email': email},
        options: Options(extra: const {'skipAuth': true}),
      );
      // 서버 스펙: { "duplicate": true/false }
      return (response.data?['duplicate'] as bool?) ?? false;
    } on DioException catch (e) {
      throw AuthException(
        friendlyMessageFromError(e),
        code: e.response?.statusCode?.toString(),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<void>(ApiEndpoints.logout);
    } on DioException {
      // 서버 통지 실패해도 로컬 로그아웃은 진행한다.
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await storage.readAccessToken();
    if (token == null || token.isEmpty) return null;
    try {
      final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
      return User.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return null;
      throw AuthException(
        friendlyMessageFromError(e),
        code: e.response?.statusCode?.toString(),
      );
    }
  }
}
