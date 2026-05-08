import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 보안 저장소 래퍼.
///
/// JWT 액세스/리프레시 토큰처럼 민감한 정보를 저장한다.
/// 일반 설정값은 `shared_preferences`를 사용할 것.
class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? _defaultStorage();

  final FlutterSecureStorage _storage;

  // Keys
  static const String _kAccessToken = 'access_token';
  static const String _kRefreshToken = 'refresh_token';

  static FlutterSecureStorage _defaultStorage() {
    return const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  // ---- Access Token ----

  Future<String?> readAccessToken() => _storage.read(key: _kAccessToken);

  Future<void> writeAccessToken(String token) =>
      _storage.write(key: _kAccessToken, value: token);

  Future<void> deleteAccessToken() => _storage.delete(key: _kAccessToken);

  // ---- Refresh Token ----

  Future<String?> readRefreshToken() => _storage.read(key: _kRefreshToken);

  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _kRefreshToken, value: token);

  Future<void> deleteRefreshToken() => _storage.delete(key: _kRefreshToken);

  // ---- All ----

  /// 로그인 성공 시 호출.
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await writeAccessToken(accessToken);
    if (refreshToken != null) {
      await writeRefreshToken(refreshToken);
    }
  }

  /// 로그아웃 또는 401 시 호출.
  Future<void> clearTokens() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }

  /// 로그인 여부.
  Future<bool> hasAccessToken() async {
    final token = await readAccessToken();
    return token != null && token.isNotEmpty;
  }
}

/// 앱 전역 [SecureStorage] 싱글턴 provider.
final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());
