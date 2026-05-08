// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventSummaryDtoImpl _$$EventSummaryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$EventSummaryDtoImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  venueName: json['venueName'] as String,
  dateRange: json['dateRange'] as String?,
  representativeDate: json['representativeDate'] as String?,
  category: json['category'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  distance: (json['distance'] as num?)?.toDouble(),
  distanceDisplay: json['distanceDisplay'] as String?,
  minPrice: (json['minPrice'] as num?)?.toInt(),
  maxPrice: (json['maxPrice'] as num?)?.toInt(),
);

Map<String, dynamic> _$$EventSummaryDtoImplToJson(
  _$EventSummaryDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'venueName': instance.venueName,
  'dateRange': instance.dateRange,
  'representativeDate': instance.representativeDate,
  'category': instance.category,
  'thumbnailUrl': instance.thumbnailUrl,
  'distance': instance.distance,
  'distanceDisplay': instance.distanceDisplay,
  'minPrice': instance.minPrice,
  'maxPrice': instance.maxPrice,
};
