import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/seat_preference.dart';

part 'signup_request.freezed.dart';
part 'signup_request.g.dart';

/// 회원가입 요청 DTO. 백엔드 `POST /api/v1/auth/signup` 와 1:1 매핑.
///
/// 백엔드 필드:
///   email, password, username, phone, seatPreference (NONE | EYESIGHT | LEG | HEARING)
///
/// `SeatPreference` enum 은 `@JsonValue` 로 대문자 와이어 포맷에 매핑됨.
@freezed
class SignupRequest with _$SignupRequest {
  const factory SignupRequest({
    required String email,
    required String password,
    required String username,
    String? phone,
    required SeatPreference seatPreference,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}
