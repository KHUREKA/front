// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationResponseDtoImpl _$$ApplicationResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationResponseDtoImpl(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  requestedSeatCount: (json['requestedSeatCount'] as num).toInt(),
  autoAssign: json['autoAssign'] as bool,
  appliedAt: json['appliedAt'] as String,
  lotteryResultAt: json['lotteryResultAt'] as String?,
  paidAt: json['paidAt'] as String?,
  applicationCode: json['applicationCode'] as String?,
  eventId: (json['eventId'] as num?)?.toInt(),
  eventTitle: json['eventTitle'] as String,
  venueName: json['venueName'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  startTime: json['startTime'] as String,
  lotteryAt: json['lotteryAt'] as String,
  priority1ZoneName: json['priority1ZoneName'] as String?,
  priority2ZoneName: json['priority2ZoneName'] as String?,
  priority3ZoneName: json['priority3ZoneName'] as String?,
  assignedZoneName: json['assignedZoneName'] as String?,
  mockPaymentStatus: json['mockPaymentStatus'] as String?,
);

Map<String, dynamic> _$$ApplicationResponseDtoImplToJson(
  _$ApplicationResponseDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'requestedSeatCount': instance.requestedSeatCount,
  'autoAssign': instance.autoAssign,
  'appliedAt': instance.appliedAt,
  'lotteryResultAt': instance.lotteryResultAt,
  'paidAt': instance.paidAt,
  'applicationCode': instance.applicationCode,
  'eventId': instance.eventId,
  'eventTitle': instance.eventTitle,
  'venueName': instance.venueName,
  'thumbnailUrl': instance.thumbnailUrl,
  'startTime': instance.startTime,
  'lotteryAt': instance.lotteryAt,
  'priority1ZoneName': instance.priority1ZoneName,
  'priority2ZoneName': instance.priority2ZoneName,
  'priority3ZoneName': instance.priority3ZoneName,
  'assignedZoneName': instance.assignedZoneName,
  'mockPaymentStatus': instance.mockPaymentStatus,
};
