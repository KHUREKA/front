// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssignedSeatInfoDtoImpl _$$AssignedSeatInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AssignedSeatInfoDtoImpl(
  rowLabel: json['rowLabel'] as String,
  seatNumber: json['seatNumber'] as String,
  ticketCode: json['ticketCode'] as String,
);

Map<String, dynamic> _$$AssignedSeatInfoDtoImplToJson(
  _$AssignedSeatInfoDtoImpl instance,
) => <String, dynamic>{
  'rowLabel': instance.rowLabel,
  'seatNumber': instance.seatNumber,
  'ticketCode': instance.ticketCode,
};

_$TicketResponseDtoImpl _$$TicketResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TicketResponseDtoImpl(
  applicationId: (json['applicationId'] as num).toInt(),
  applicationCode: json['applicationCode'] as String,
  status: json['status'] as String,
  paidAt: json['paidAt'] as String?,
  eventTitle: json['eventTitle'] as String,
  venueName: json['venueName'] as String,
  venueAddress: json['venueAddress'] as String?,
  destinationLatitude: (json['destinationLatitude'] as num?)?.toDouble(),
  destinationLongitude: (json['destinationLongitude'] as num?)?.toDouble(),
  startTime: json['startTime'] as String,
  assignedZoneName: json['assignedZoneName'] as String?,
  zonePrice: (json['zonePrice'] as num?)?.toInt(),
  seats:
      (json['seats'] as List<dynamic>?)
          ?.map((e) => AssignedSeatInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AssignedSeatInfoDto>[],
);

Map<String, dynamic> _$$TicketResponseDtoImplToJson(
  _$TicketResponseDtoImpl instance,
) => <String, dynamic>{
  'applicationId': instance.applicationId,
  'applicationCode': instance.applicationCode,
  'status': instance.status,
  'paidAt': instance.paidAt,
  'eventTitle': instance.eventTitle,
  'venueName': instance.venueName,
  'venueAddress': instance.venueAddress,
  'destinationLatitude': instance.destinationLatitude,
  'destinationLongitude': instance.destinationLongitude,
  'startTime': instance.startTime,
  'assignedZoneName': instance.assignedZoneName,
  'zonePrice': instance.zonePrice,
  'seats': instance.seats,
};
