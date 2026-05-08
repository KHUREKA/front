// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_zone_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SeatZoneDtoImpl _$$SeatZoneDtoImplFromJson(Map<String, dynamic> json) =>
    _$SeatZoneDtoImpl(
      id: (json['id'] as num).toInt(),
      scheduleId: (json['scheduleId'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SeatZoneDtoImplToJson(_$SeatZoneDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'name': instance.name,
      'price': instance.price,
      'availableSeats': instance.availableSeats,
    };
