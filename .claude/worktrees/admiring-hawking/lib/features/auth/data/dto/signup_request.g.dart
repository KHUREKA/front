// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupRequestImpl _$$SignupRequestImplFromJson(Map<String, dynamic> json) =>
    _$SignupRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String?,
      seatPreference: $enumDecode(
        _$SeatPreferenceEnumMap,
        json['seatPreference'],
      ),
    );

Map<String, dynamic> _$$SignupRequestImplToJson(_$SignupRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'username': instance.username,
      'phone': instance.phone,
      'seatPreference': _$SeatPreferenceEnumMap[instance.seatPreference]!,
    };

const _$SeatPreferenceEnumMap = {
  SeatPreference.none: 'NONE',
  SeatPreference.eyesight: 'EYESIGHT',
  SeatPreference.leg: 'LEG',
  SeatPreference.hearing: 'HEARING',
};
