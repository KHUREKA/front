import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

/// 로그인/회원가입 성공 시 서버 응답.
///
/// 백엔드(`POST /api/v1/auth/login`)는 다음 형태로 내려준다:
///   { "accessToken": "...", "tokenType": "Bearer" }
/// 사용자 정보는 별도 엔드포인트가 없으므로 토큰의 JWT 클레임에서 꺼낸다.
/// (`auth_provider.applyAuthResponse` 참고)
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    @Default('Bearer') String tokenType,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
