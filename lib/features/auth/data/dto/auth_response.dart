import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/user.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

/// 로그인/회원가입 성공 시 서버 응답.
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    String? refreshToken,
    required User user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
