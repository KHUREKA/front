// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationRequestDtoImpl _$$ApplicationRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationRequestDtoImpl(
  scheduleId: (json['scheduleId'] as num).toInt(),
  requestedSeatCount: (json['requestedSeatCount'] as num).toInt(),
  autoAssign: json['autoAssign'] as bool,
  priority1SeatZoneId: (json['priority1SeatZoneId'] as num?)?.toInt(),
  priority2SeatZoneId: (json['priority2SeatZoneId'] as num?)?.toInt(),
  priority3SeatZoneId: (json['priority3SeatZoneId'] as num?)?.toInt(),
  autoPaymentAgreed: json['autoPaymentAgreed'] as bool? ?? true,
  seatPreference: json['seatPreference'] as String?,
);

Map<String, dynamic> _$$ApplicationRequestDtoImplToJson(
  _$ApplicationRequestDtoImpl instance,
) => <String, dynamic>{
  'scheduleId': instance.scheduleId,
  'requestedSeatCount': instance.requestedSeatCount,
  'autoAssign': instance.autoAssign,
  'priority1SeatZoneId': instance.priority1SeatZoneId,
  'priority2SeatZoneId': instance.priority2SeatZoneId,
  'priority3SeatZoneId': instance.priority3SeatZoneId,
  'autoPaymentAgreed': instance.autoPaymentAgreed,
  'seatPreference': instance.seatPreference,
};
