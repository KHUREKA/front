// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_schedule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventScheduleDtoImpl _$$EventScheduleDtoImplFromJson(
  Map<String, dynamic> json,
) => _$EventScheduleDtoImpl(
  id: (json['id'] as num).toInt(),
  eventId: (json['eventId'] as num).toInt(),
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String?,
  applicationOpenAt: json['applicationOpenAt'] as String,
  applicationCloseAt: json['applicationCloseAt'] as String,
  lotteryAt: json['lotteryAt'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$$EventScheduleDtoImplToJson(
  _$EventScheduleDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'applicationOpenAt': instance.applicationOpenAt,
  'applicationCloseAt': instance.applicationCloseAt,
  'lotteryAt': instance.lotteryAt,
  'status': instance.status,
};
