// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmap_transit_route_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TmapTransitRouteDtoImpl _$$TmapTransitRouteDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TmapTransitRouteDtoImpl(
  eventId: (json['eventId'] as num).toInt(),
  eventTitle: json['eventTitle'] as String,
  venueName: json['venueName'] as String,
  venueAddress: json['venueAddress'] as String?,
  startLatitude: (json['startLatitude'] as num?)?.toDouble(),
  startLongitude: (json['startLongitude'] as num?)?.toDouble(),
  destinationLatitude: (json['destinationLatitude'] as num?)?.toDouble(),
  destinationLongitude: (json['destinationLongitude'] as num?)?.toDouble(),
  totalTime: (json['totalTime'] as num?)?.toInt() ?? 0,
  payment: (json['payment'] as num?)?.toInt() ?? 0,
  transferCount: (json['transferCount'] as num?)?.toInt() ?? 0,
  totalWalk: (json['totalWalk'] as num?)?.toInt() ?? 0,
  firstStation: json['firstStation'] as String?,
  lastStation: json['lastStation'] as String?,
  summaryMessage: json['summaryMessage'] as String?,
  segments:
      (json['segments'] as List<dynamic>?)
          ?.map((e) => TransitSegmentDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TransitSegmentDto>[],
  accessibilityGuide: json['accessibilityGuide'] == null
      ? null
      : AccessibilityGuideDto.fromJson(
          json['accessibilityGuide'] as Map<String, dynamic>,
        ),
  provider: json['provider'] as String?,
);

Map<String, dynamic> _$$TmapTransitRouteDtoImplToJson(
  _$TmapTransitRouteDtoImpl instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'eventTitle': instance.eventTitle,
  'venueName': instance.venueName,
  'venueAddress': instance.venueAddress,
  'startLatitude': instance.startLatitude,
  'startLongitude': instance.startLongitude,
  'destinationLatitude': instance.destinationLatitude,
  'destinationLongitude': instance.destinationLongitude,
  'totalTime': instance.totalTime,
  'payment': instance.payment,
  'transferCount': instance.transferCount,
  'totalWalk': instance.totalWalk,
  'firstStation': instance.firstStation,
  'lastStation': instance.lastStation,
  'summaryMessage': instance.summaryMessage,
  'segments': instance.segments,
  'accessibilityGuide': instance.accessibilityGuide,
  'provider': instance.provider,
};

_$TransitSegmentDtoImpl _$$TransitSegmentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TransitSegmentDtoImpl(
  order: (json['order'] as num?)?.toInt() ?? 0,
  mode: json['mode'] as String,
  sectionTime: (json['sectionTime'] as num?)?.toInt() ?? 0,
  startName: json['startName'] as String?,
  endName: json['endName'] as String?,
  displayName: json['displayName'] as String?,
  color: json['color'] as String?,
  busLabel: json['busLabel'] as String?,
  busNumbers:
      (json['busNumbers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  subwayLine: json['subwayLine'] as String?,
);

Map<String, dynamic> _$$TransitSegmentDtoImplToJson(
  _$TransitSegmentDtoImpl instance,
) => <String, dynamic>{
  'order': instance.order,
  'mode': instance.mode,
  'sectionTime': instance.sectionTime,
  'startName': instance.startName,
  'endName': instance.endName,
  'displayName': instance.displayName,
  'color': instance.color,
  'busLabel': instance.busLabel,
  'busNumbers': instance.busNumbers,
  'subwayLine': instance.subwayLine,
};

_$AccessibilityGuideDtoImpl _$$AccessibilityGuideDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AccessibilityGuideDtoImpl(
  nearestStation: json['nearestStation'] as String?,
  recommendedExit: json['recommendedExit'] as String?,
  caution: json['caution'] as String?,
);

Map<String, dynamic> _$$AccessibilityGuideDtoImplToJson(
  _$AccessibilityGuideDtoImpl instance,
) => <String, dynamic>{
  'nearestStation': instance.nearestStation,
  'recommendedExit': instance.recommendedExit,
  'caution': instance.caution,
};
