// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PerformanceDtoImpl _$$PerformanceDtoImplFromJson(Map<String, dynamic> json) =>
    _$PerformanceDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      posterImageUrl: json['posterImageUrl'] as String,
      venue: json['venue'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      genre: json['genre'] as String,
      priceMin: (json['priceMin'] as num).toInt(),
      priceMax: (json['priceMax'] as num).toInt(),
      isLotteryOpen: json['isLotteryOpen'] as bool? ?? false,
      lotteryDeadline: json['lotteryDeadline'] as String?,
    );

Map<String, dynamic> _$$PerformanceDtoImplToJson(
  _$PerformanceDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'posterImageUrl': instance.posterImageUrl,
  'venue': instance.venue,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'distanceKm': instance.distanceKm,
  'genre': instance.genre,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
  'isLotteryOpen': instance.isLotteryOpen,
  'lotteryDeadline': instance.lotteryDeadline,
};
