// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mypage_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MyPageProfileDtoImpl _$$MyPageProfileDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MyPageProfileDtoImpl(
  email: json['email'] as String,
  username: json['username'] as String,
  phone: json['phone'] as String?,
  seatPreference: $enumDecodeNullable(
    _$SeatPreferenceEnumMap,
    json['seatPreference'],
  ),
);

Map<String, dynamic> _$$MyPageProfileDtoImplToJson(
  _$MyPageProfileDtoImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'username': instance.username,
  'phone': instance.phone,
  'seatPreference': _$SeatPreferenceEnumMap[instance.seatPreference],
};

const _$SeatPreferenceEnumMap = {
  SeatPreference.none: 'NONE',
  SeatPreference.eyesight: 'EYESIGHT',
  SeatPreference.leg: 'LEG',
  SeatPreference.hearing: 'HEARING',
};
