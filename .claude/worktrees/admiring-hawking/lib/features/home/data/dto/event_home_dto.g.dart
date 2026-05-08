// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_home_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventHomeDtoImpl _$$EventHomeDtoImplFromJson(Map<String, dynamic> json) =>
    _$EventHomeDtoImpl(
      nearbyEvents:
          (json['nearbyEvents'] as List<dynamic>?)
              ?.map((e) => EventSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EventSummaryDto>[],
      recommendedEvents:
          (json['recommendedEvents'] as List<dynamic>?)
              ?.map((e) => EventSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EventSummaryDto>[],
    );

Map<String, dynamic> _$$EventHomeDtoImplToJson(_$EventHomeDtoImpl instance) =>
    <String, dynamic>{
      'nearbyEvents': instance.nearbyEvents,
      'recommendedEvents': instance.recommendedEvents,
    };
