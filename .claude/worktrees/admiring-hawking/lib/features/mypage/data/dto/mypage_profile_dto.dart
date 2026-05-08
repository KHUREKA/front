import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/seat_preference.dart';

part 'mypage_profile_dto.freezed.dart';
part 'mypage_profile_dto.g.dart';

/// 백엔드 `UserProfileResponse` 1:1 매핑.
///
/// `GET /api/v1/mypage/me` / `PUT /api/v1/mypage/me` 양쪽 응답.
///
/// JWT 클레임에는 phone / seatPreference 가 없어서, 이 endpoint 가
/// "로그인 후에만 알 수 있는 추가 사용자 정보"의 유일한 소스다.
@freezed
class MyPageProfileDto with _$MyPageProfileDto {
  const factory MyPageProfileDto({
    required String email,
    required String username,
    String? phone,
    SeatPreference? seatPreference,
  }) = _MyPageProfileDto;

  factory MyPageProfileDto.fromJson(Map<String, dynamic> json) =>
      _$MyPageProfileDtoFromJson(json);
}
