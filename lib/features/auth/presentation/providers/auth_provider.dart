import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  Future<void> applyAuthResponse(AuthResponse response) async {
    await _storage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    state = state.copyWith(user: response.user, isBootstrapping: false);
  }

  /// 로그아웃.
  Future<void> logout() async {
    try {
      await _repo.logout();
    } on AuthException {
      // 서버 통지 실패는 무시
    }
    await _storage.clearTokens();
    state = state.copyWith(user: null, isBootstrapping: false);
  }

  /// 401 인터셉터에서 호출. 서버 통지 없이 로컬만 정리.
  Future<void> forceLogout() async {
    await _storage.clearTokens();
    state = state.copyWith(user: null, isBootstrapping: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
