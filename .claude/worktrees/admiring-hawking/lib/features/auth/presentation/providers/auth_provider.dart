import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/auth_repository.dart';
import '../../data/dto/auth_response.dart';
import '../../domain/user.dart';

part 'auth_provider.freezed.dart';

/// 앱 전역 인증 상태.
///
/// - [isBootstrapping]: 앱 시작 시 토큰 확인 중인지
/// - [user]: 로그인된 사용자. `null` 이면 비로그인.
@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(true) bool isBootstrapping,
    User? user,
  }) = _AuthState;

  bool get isAuthenticated => user != null;
}

/// 인증 상태 관리.
///
/// 라우터의 redirect 가드, 로그인/회원가입 화면, 마이페이지 등에서 모두 구독.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(const AuthState());

  final Ref _ref;

  AuthRepository get _repo => _ref.read(authRepositoryProvider);
  SecureStorage get _storage => _ref.read(secureStorageProvider);

  /// 앱 시작 시 1회 호출.
  /// 저장된 토큰이 있으면 사용자 정보를 가져와 로그인 상태로 복구.
  Future<void> bootstrap() async {
    final hasToken = await _storage.hasAccessToken();
    if (!hasToken) {
      state = state.copyWith(isBootstrapping: false, user: null);
      return;
    }
    try {
      final user = await _repo.getCurrentUser();
      state = state.copyWith(isBootstrapping: false, user: user);
    } on AuthException {
      // 토큰이 무효하면 로컬 정리
      await _storage.clearTokens();
      state = state.copyWith(isBootstrapping: false, user: null);
    }
  }

  /// 로그인 성공 후 호출.
  ///
  /// 백엔드 응답에는 user 정보가 없으므로 JWT 클레임에서 직접 만든다.
  /// 토큰 클레임: { sub: email, username, userId, auth }
  Future<void> applyAuthResponse(AuthResponse response) async {
    await _storage.saveTokens(accessToken: response.accessToken);
    final claims = JwtDecoder.decode(response.accessToken);
    final user = UserJwt.fromJwtClaims(claims);
    state = state.copyWith(user: user, isBootstrapping: false);
  }

  /// 로그아웃.
  Future<void> logout() async {
    try {
      await _repo.logout();
    } on AuthException {
      // 서버 통지 실패는 무시
    }
    await _storage.clearTokens();
    _ref.read(locationServiceProvider).clearCache();
    state = state.copyWith(user: null, isBootstrapping: false);
  }

  /// 마이페이지에서 이름/전화번호를 수정한 직후 호출.
  /// JWT 디코드로 만든 user 의 일부를 메모리에서 갱신해, 같은 세션 안에서
  /// 다른 화면(홈 그리팅 등)도 새 값을 보게 한다.
  /// (실제 신뢰 가능한 값은 `userProfileProvider` 가 백엔드에서 다시 가져옴)
  void syncProfileFields({String? name, String? phone}) {
    final current = state.user;
    if (current == null) return;
    state = state.copyWith(
      user: User(
        id: current.id,
        email: current.email,
        name: name ?? current.name,
        phone: phone ?? current.phone,
        genres: current.genres,
      ),
    );
  }

  /// 401 인터셉터에서 호출. 서버 통지 없이 로컬만 정리.
  Future<void> forceLogout() async {
    await _storage.clearTokens();
    _ref.read(locationServiceProvider).clearCache();
    state = state.copyWith(user: null, isBootstrapping: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
