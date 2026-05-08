// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tmap_transit_route_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TmapTransitRouteDto _$TmapTransitRouteDtoFromJson(Map<String, dynamic> json) {
  return _TmapTransitRouteDto.fromJson(json);
}

/// @nodoc
mixin _$TmapTransitRouteDto {
  int get eventId => throw _privateConstructorUsedError;
  String get eventTitle => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String? get venueAddress => throw _privateConstructorUsedError;
  double? get startLatitude => throw _privateConstructorUsedError;
  double? get startLongitude => throw _privateConstructorUsedError;
  double? get destinationLatitude => throw _privateConstructorUsedError;
  double? get destinationLongitude => throw _privateConstructorUsedError;
  int get totalTime => throw _privateConstructorUsedError; // 총 소요(분)
  int get payment => throw _privateConstructorUsedError; // 요금(원)
  int get transferCount => throw _privateConstructorUsedError; // 환승 횟수
  int get totalWalk => throw _privateConstructorUsedError; // 총 도보 거리(미터)
  String? get firstStation => throw _privateConstructorUsedError;
  String? get lastStation => throw _privateConstructorUsedError;
  String? get summaryMessage => throw _privateConstructorUsedError;
  List<TransitSegmentDto> get segments => throw _privateConstructorUsedError;
  AccessibilityGuideDto? get accessibilityGuide =>
      throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;

  /// Serializes this TmapTransitRouteDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TmapTransitRouteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TmapTransitRouteDtoCopyWith<TmapTransitRouteDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TmapTransitRouteDtoCopyWith<$Res> {
  factory $TmapTransitRouteDtoCopyWith(
    TmapTransitRouteDto value,
    $Res Function(TmapTransitRouteDto) then,
  ) = _$TmapTransitRouteDtoCopyWithImpl<$Res, TmapTransitRouteDto>;
  @useResult
  $Res call({
    int eventId,
    String eventTitle,
    String venueName,
    String? venueAddress,
    double? startLatitude,
    double? startLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    int totalTime,
    int payment,
    int transferCount,
    int totalWalk,
    String? firstStation,
    String? lastStation,
    String? summaryMessage,
    List<TransitSegmentDto> segments,
    AccessibilityGuideDto? accessibilityGuide,
    String? provider,
  });

  $AccessibilityGuideDtoCopyWith<$Res>? get accessibilityGuide;
}

/// @nodoc
class _$TmapTransitRouteDtoCopyWithImpl<$Res, $Val extends TmapTransitRouteDto>
    implements $TmapTransitRouteDtoCopyWith<$Res> {
  _$TmapTransitRouteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TmapTransitRouteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventTitle = null,
    Object? venueName = null,
    Object? venueAddress = freezed,
    Object? startLatitude = freezed,
    Object? startLongitude = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? totalTime = null,
    Object? payment = null,
    Object? transferCount = null,
    Object? totalWalk = null,
    Object? firstStation = freezed,
    Object? lastStation = freezed,
    Object? summaryMessage = freezed,
    Object? segments = null,
    Object? accessibilityGuide = freezed,
    Object? provider = freezed,
  }) {
    return _then(
      _value.copyWith(
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as int,
            eventTitle: null == eventTitle
                ? _value.eventTitle
                : eventTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            venueName: null == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String,
            venueAddress: freezed == venueAddress
                ? _value.venueAddress
                : venueAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            startLatitude: freezed == startLatitude
                ? _value.startLatitude
                : startLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            startLongitude: freezed == startLongitude
                ? _value.startLongitude
                : startLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            destinationLatitude: freezed == destinationLatitude
                ? _value.destinationLatitude
                : destinationLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            destinationLongitude: freezed == destinationLongitude
                ? _value.destinationLongitude
                : destinationLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalTime: null == totalTime
                ? _value.totalTime
                : totalTime // ignore: cast_nullable_to_non_nullable
                      as int,
            payment: null == payment
                ? _value.payment
                : payment // ignore: cast_nullable_to_non_nullable
                      as int,
            transferCount: null == transferCount
                ? _value.transferCount
                : transferCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalWalk: null == totalWalk
                ? _value.totalWalk
                : totalWalk // ignore: cast_nullable_to_non_nullable
                      as int,
            firstStation: freezed == firstStation
                ? _value.firstStation
                : firstStation // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastStation: freezed == lastStation
                ? _value.lastStation
                : lastStation // ignore: cast_nullable_to_non_nullable
                      as String?,
            summaryMessage: freezed == summaryMessage
                ? _value.summaryMessage
                : summaryMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            segments: null == segments
                ? _value.segments
                : segments // ignore: cast_nullable_to_non_nullable
                      as List<TransitSegmentDto>,
            accessibilityGuide: freezed == accessibilityGuide
                ? _value.accessibilityGuide
                : accessibilityGuide // ignore: cast_nullable_to_non_nullable
                      as AccessibilityGuideDto?,
            provider: freezed == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TmapTransitRouteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccessibilityGuideDtoCopyWith<$Res>? get accessibilityGuide {
    if (_value.accessibilityGuide == null) {
      return null;
    }

    return $AccessibilityGuideDtoCopyWith<$Res>(_value.accessibilityGuide!, (
      value,
    ) {
      return _then(_value.copyWith(accessibilityGuide: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TmapTransitRouteDtoImplCopyWith<$Res>
    implements $TmapTransitRouteDtoCopyWith<$Res> {
  factory _$$TmapTransitRouteDtoImplCopyWith(
    _$TmapTransitRouteDtoImpl value,
    $Res Function(_$TmapTransitRouteDtoImpl) then,
  ) = __$$TmapTransitRouteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int eventId,
    String eventTitle,
    String venueName,
    String? venueAddress,
    double? startLatitude,
    double? startLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    int totalTime,
    int payment,
    int transferCount,
    int totalWalk,
    String? firstStation,
    String? lastStation,
    String? summaryMessage,
    List<TransitSegmentDto> segments,
    AccessibilityGuideDto? accessibilityGuide,
    String? provider,
  });

  @override
  $AccessibilityGuideDtoCopyWith<$Res>? get accessibilityGuide;
}

/// @nodoc
class __$$TmapTransitRouteDtoImplCopyWithImpl<$Res>
    extends _$TmapTransitRouteDtoCopyWithImpl<$Res, _$TmapTransitRouteDtoImpl>
    implements _$$TmapTransitRouteDtoImplCopyWith<$Res> {
  __$$TmapTransitRouteDtoImplCopyWithImpl(
    _$TmapTransitRouteDtoImpl _value,
    $Res Function(_$TmapTransitRouteDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TmapTransitRouteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventTitle = null,
    Object? venueName = null,
    Object? venueAddress = freezed,
    Object? startLatitude = freezed,
    Object? startLongitude = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? totalTime = null,
    Object? payment = null,
    Object? transferCount = null,
    Object? totalWalk = null,
    Object? firstStation = freezed,
    Object? lastStation = freezed,
    Object? summaryMessage = freezed,
    Object? segments = null,
    Object? accessibilityGuide = freezed,
    Object? provider = freezed,
  }) {
    return _then(
      _$TmapTransitRouteDtoImpl(
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as int,
        eventTitle: null == eventTitle
            ? _value.eventTitle
            : eventTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        venueName: null == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String,
        venueAddress: freezed == venueAddress
            ? _value.venueAddress
            : venueAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        startLatitude: freezed == startLatitude
            ? _value.startLatitude
            : startLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        startLongitude: freezed == startLongitude
            ? _value.startLongitude
            : startLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        destinationLatitude: freezed == destinationLatitude
            ? _value.destinationLatitude
            : destinationLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        destinationLongitude: freezed == destinationLongitude
            ? _value.destinationLongitude
            : destinationLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalTime: null == totalTime
            ? _value.totalTime
            : totalTime // ignore: cast_nullable_to_non_nullable
                  as int,
        payment: null == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                  as int,
        transferCount: null == transferCount
            ? _value.transferCount
            : transferCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalWalk: null == totalWalk
            ? _value.totalWalk
            : totalWalk // ignore: cast_nullable_to_non_nullable
                  as int,
        firstStation: freezed == firstStation
            ? _value.firstStation
            : firstStation // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastStation: freezed == lastStation
            ? _value.lastStation
            : lastStation // ignore: cast_nullable_to_non_nullable
                  as String?,
        summaryMessage: freezed == summaryMessage
            ? _value.summaryMessage
            : summaryMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        segments: null == segments
            ? _value._segments
            : segments // ignore: cast_nullable_to_non_nullable
                  as List<TransitSegmentDto>,
        accessibilityGuide: freezed == accessibilityGuide
            ? _value.accessibilityGuide
            : accessibilityGuide // ignore: cast_nullable_to_non_nullable
                  as AccessibilityGuideDto?,
        provider: freezed == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TmapTransitRouteDtoImpl implements _TmapTransitRouteDto {
  const _$TmapTransitRouteDtoImpl({
    required this.eventId,
    required this.eventTitle,
    required this.venueName,
    this.venueAddress,
    this.startLatitude,
    this.startLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
    this.totalTime = 0,
    this.payment = 0,
    this.transferCount = 0,
    this.totalWalk = 0,
    this.firstStation,
    this.lastStation,
    this.summaryMessage,
    final List<TransitSegmentDto> segments = const <TransitSegmentDto>[],
    this.accessibilityGuide,
    this.provider,
  }) : _segments = segments;

  factory _$TmapTransitRouteDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TmapTransitRouteDtoImplFromJson(json);

  @override
  final int eventId;
  @override
  final String eventTitle;
  @override
  final String venueName;
  @override
  final String? venueAddress;
  @override
  final double? startLatitude;
  @override
  final double? startLongitude;
  @override
  final double? destinationLatitude;
  @override
  final double? destinationLongitude;
  @override
  @JsonKey()
  final int totalTime;
  // 총 소요(분)
  @override
  @JsonKey()
  final int payment;
  // 요금(원)
  @override
  @JsonKey()
  final int transferCount;
  // 환승 횟수
  @override
  @JsonKey()
  final int totalWalk;
  // 총 도보 거리(미터)
  @override
  final String? firstStation;
  @override
  final String? lastStation;
  @override
  final String? summaryMessage;
  final List<TransitSegmentDto> _segments;
  @override
  @JsonKey()
  List<TransitSegmentDto> get segments {
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_segments);
  }

  @override
  final AccessibilityGuideDto? accessibilityGuide;
  @override
  final String? provider;

  @override
  String toString() {
    return 'TmapTransitRouteDto(eventId: $eventId, eventTitle: $eventTitle, venueName: $venueName, venueAddress: $venueAddress, startLatitude: $startLatitude, startLongitude: $startLongitude, destinationLatitude: $destinationLatitude, destinationLongitude: $destinationLongitude, totalTime: $totalTime, payment: $payment, transferCount: $transferCount, totalWalk: $totalWalk, firstStation: $firstStation, lastStation: $lastStation, summaryMessage: $summaryMessage, segments: $segments, accessibilityGuide: $accessibilityGuide, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TmapTransitRouteDtoImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            (identical(other.startLatitude, startLatitude) ||
                other.startLatitude == startLatitude) &&
            (identical(other.startLongitude, startLongitude) ||
                other.startLongitude == startLongitude) &&
            (identical(other.destinationLatitude, destinationLatitude) ||
                other.destinationLatitude == destinationLatitude) &&
            (identical(other.destinationLongitude, destinationLongitude) ||
                other.destinationLongitude == destinationLongitude) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            (identical(other.payment, payment) || other.payment == payment) &&
            (identical(other.transferCount, transferCount) ||
                other.transferCount == transferCount) &&
            (identical(other.totalWalk, totalWalk) ||
                other.totalWalk == totalWalk) &&
            (identical(other.firstStation, firstStation) ||
                other.firstStation == firstStation) &&
            (identical(other.lastStation, lastStation) ||
                other.lastStation == lastStation) &&
            (identical(other.summaryMessage, summaryMessage) ||
                other.summaryMessage == summaryMessage) &&
            const DeepCollectionEquality().equals(other._segments, _segments) &&
            (identical(other.accessibilityGuide, accessibilityGuide) ||
                other.accessibilityGuide == accessibilityGuide) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    eventId,
    eventTitle,
    venueName,
    venueAddress,
    startLatitude,
    startLongitude,
    destinationLatitude,
    destinationLongitude,
    totalTime,
    payment,
    transferCount,
    totalWalk,
    firstStation,
    lastStation,
    summaryMessage,
    const DeepCollectionEquality().hash(_segments),
    accessibilityGuide,
    provider,
  );

  /// Create a copy of TmapTransitRouteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TmapTransitRouteDtoImplCopyWith<_$TmapTransitRouteDtoImpl> get copyWith =>
      __$$TmapTransitRouteDtoImplCopyWithImpl<_$TmapTransitRouteDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TmapTransitRouteDtoImplToJson(this);
  }
}

abstract class _TmapTransitRouteDto implements TmapTransitRouteDto {
  const factory _TmapTransitRouteDto({
    required final int eventId,
    required final String eventTitle,
    required final String venueName,
    final String? venueAddress,
    final double? startLatitude,
    final double? startLongitude,
    final double? destinationLatitude,
    final double? destinationLongitude,
    final int totalTime,
    final int payment,
    final int transferCount,
    final int totalWalk,
    final String? firstStation,
    final String? lastStation,
    final String? summaryMessage,
    final List<TransitSegmentDto> segments,
    final AccessibilityGuideDto? accessibilityGuide,
    final String? provider,
  }) = _$TmapTransitRouteDtoImpl;

  factory _TmapTransitRouteDto.fromJson(Map<String, dynamic> json) =
      _$TmapTransitRouteDtoImpl.fromJson;

  @override
  int get eventId;
  @override
  String get eventTitle;
  @override
  String get venueName;
  @override
  String? get venueAddress;
  @override
  double? get startLatitude;
  @override
  double? get startLongitude;
  @override
  double? get destinationLatitude;
  @override
  double? get destinationLongitude;
  @override
  int get totalTime; // 총 소요(분)
  @override
  int get payment; // 요금(원)
  @override
  int get transferCount; // 환승 횟수
  @override
  int get totalWalk; // 총 도보 거리(미터)
  @override
  String? get firstStation;
  @override
  String? get lastStation;
  @override
  String? get summaryMessage;
  @override
  List<TransitSegmentDto> get segments;
  @override
  AccessibilityGuideDto? get accessibilityGuide;
  @override
  String? get provider;

  /// Create a copy of TmapTransitRouteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TmapTransitRouteDtoImplCopyWith<_$TmapTransitRouteDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransitSegmentDto _$TransitSegmentDtoFromJson(Map<String, dynamic> json) {
  return _TransitSegmentDto.fromJson(json);
}

/// @nodoc
mixin _$TransitSegmentDto {
  int get order => throw _privateConstructorUsedError;
  String get mode =>
      throw _privateConstructorUsedError; // "버스" | "지하철" | "도보" 등
  int get sectionTime => throw _privateConstructorUsedError; // 분
  String? get startName => throw _privateConstructorUsedError;
  String? get endName => throw _privateConstructorUsedError;
  String? get displayName =>
      throw _privateConstructorUsedError; // 예: "5100번 버스 탑승"
  String? get color => throw _privateConstructorUsedError; // "#0068B7" 같은 hex
  String? get busLabel => throw _privateConstructorUsedError;
  List<String> get busNumbers => throw _privateConstructorUsedError;
  String? get subwayLine => throw _privateConstructorUsedError;

  /// Serializes this TransitSegmentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransitSegmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransitSegmentDtoCopyWith<TransitSegmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransitSegmentDtoCopyWith<$Res> {
  factory $TransitSegmentDtoCopyWith(
    TransitSegmentDto value,
    $Res Function(TransitSegmentDto) then,
  ) = _$TransitSegmentDtoCopyWithImpl<$Res, TransitSegmentDto>;
  @useResult
  $Res call({
    int order,
    String mode,
    int sectionTime,
    String? startName,
    String? endName,
    String? displayName,
    String? color,
    String? busLabel,
    List<String> busNumbers,
    String? subwayLine,
  });
}

/// @nodoc
class _$TransitSegmentDtoCopyWithImpl<$Res, $Val extends TransitSegmentDto>
    implements $TransitSegmentDtoCopyWith<$Res> {
  _$TransitSegmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransitSegmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? mode = null,
    Object? sectionTime = null,
    Object? startName = freezed,
    Object? endName = freezed,
    Object? displayName = freezed,
    Object? color = freezed,
    Object? busLabel = freezed,
    Object? busNumbers = null,
    Object? subwayLine = freezed,
  }) {
    return _then(
      _value.copyWith(
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as String,
            sectionTime: null == sectionTime
                ? _value.sectionTime
                : sectionTime // ignore: cast_nullable_to_non_nullable
                      as int,
            startName: freezed == startName
                ? _value.startName
                : startName // ignore: cast_nullable_to_non_nullable
                      as String?,
            endName: freezed == endName
                ? _value.endName
                : endName // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            busLabel: freezed == busLabel
                ? _value.busLabel
                : busLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
            busNumbers: null == busNumbers
                ? _value.busNumbers
                : busNumbers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            subwayLine: freezed == subwayLine
                ? _value.subwayLine
                : subwayLine // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransitSegmentDtoImplCopyWith<$Res>
    implements $TransitSegmentDtoCopyWith<$Res> {
  factory _$$TransitSegmentDtoImplCopyWith(
    _$TransitSegmentDtoImpl value,
    $Res Function(_$TransitSegmentDtoImpl) then,
  ) = __$$TransitSegmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int order,
    String mode,
    int sectionTime,
    String? startName,
    String? endName,
    String? displayName,
    String? color,
    String? busLabel,
    List<String> busNumbers,
    String? subwayLine,
  });
}

/// @nodoc
class __$$TransitSegmentDtoImplCopyWithImpl<$Res>
    extends _$TransitSegmentDtoCopyWithImpl<$Res, _$TransitSegmentDtoImpl>
    implements _$$TransitSegmentDtoImplCopyWith<$Res> {
  __$$TransitSegmentDtoImplCopyWithImpl(
    _$TransitSegmentDtoImpl _value,
    $Res Function(_$TransitSegmentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransitSegmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? mode = null,
    Object? sectionTime = null,
    Object? startName = freezed,
    Object? endName = freezed,
    Object? displayName = freezed,
    Object? color = freezed,
    Object? busLabel = freezed,
    Object? busNumbers = null,
    Object? subwayLine = freezed,
  }) {
    return _then(
      _$TransitSegmentDtoImpl(
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
        sectionTime: null == sectionTime
            ? _value.sectionTime
            : sectionTime // ignore: cast_nullable_to_non_nullable
                  as int,
        startName: freezed == startName
            ? _value.startName
            : startName // ignore: cast_nullable_to_non_nullable
                  as String?,
        endName: freezed == endName
            ? _value.endName
            : endName // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        busLabel: freezed == busLabel
            ? _value.busLabel
            : busLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
        busNumbers: null == busNumbers
            ? _value._busNumbers
            : busNumbers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        subwayLine: freezed == subwayLine
            ? _value.subwayLine
            : subwayLine // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransitSegmentDtoImpl implements _TransitSegmentDto {
  const _$TransitSegmentDtoImpl({
    this.order = 0,
    required this.mode,
    this.sectionTime = 0,
    this.startName,
    this.endName,
    this.displayName,
    this.color,
    this.busLabel,
    final List<String> busNumbers = const <String>[],
    this.subwayLine,
  }) : _busNumbers = busNumbers;

  factory _$TransitSegmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransitSegmentDtoImplFromJson(json);

  @override
  @JsonKey()
  final int order;
  @override
  final String mode;
  // "버스" | "지하철" | "도보" 등
  @override
  @JsonKey()
  final int sectionTime;
  // 분
  @override
  final String? startName;
  @override
  final String? endName;
  @override
  final String? displayName;
  // 예: "5100번 버스 탑승"
  @override
  final String? color;
  // "#0068B7" 같은 hex
  @override
  final String? busLabel;
  final List<String> _busNumbers;
  @override
  @JsonKey()
  List<String> get busNumbers {
    if (_busNumbers is EqualUnmodifiableListView) return _busNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_busNumbers);
  }

  @override
  final String? subwayLine;

  @override
  String toString() {
    return 'TransitSegmentDto(order: $order, mode: $mode, sectionTime: $sectionTime, startName: $startName, endName: $endName, displayName: $displayName, color: $color, busLabel: $busLabel, busNumbers: $busNumbers, subwayLine: $subwayLine)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransitSegmentDtoImpl &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.sectionTime, sectionTime) ||
                other.sectionTime == sectionTime) &&
            (identical(other.startName, startName) ||
                other.startName == startName) &&
            (identical(other.endName, endName) || other.endName == endName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.busLabel, busLabel) ||
                other.busLabel == busLabel) &&
            const DeepCollectionEquality().equals(
              other._busNumbers,
              _busNumbers,
            ) &&
            (identical(other.subwayLine, subwayLine) ||
                other.subwayLine == subwayLine));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    order,
    mode,
    sectionTime,
    startName,
    endName,
    displayName,
    color,
    busLabel,
    const DeepCollectionEquality().hash(_busNumbers),
    subwayLine,
  );

  /// Create a copy of TransitSegmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransitSegmentDtoImplCopyWith<_$TransitSegmentDtoImpl> get copyWith =>
      __$$TransitSegmentDtoImplCopyWithImpl<_$TransitSegmentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransitSegmentDtoImplToJson(this);
  }
}

abstract class _TransitSegmentDto implements TransitSegmentDto {
  const factory _TransitSegmentDto({
    final int order,
    required final String mode,
    final int sectionTime,
    final String? startName,
    final String? endName,
    final String? displayName,
    final String? color,
    final String? busLabel,
    final List<String> busNumbers,
    final String? subwayLine,
  }) = _$TransitSegmentDtoImpl;

  factory _TransitSegmentDto.fromJson(Map<String, dynamic> json) =
      _$TransitSegmentDtoImpl.fromJson;

  @override
  int get order;
  @override
  String get mode; // "버스" | "지하철" | "도보" 등
  @override
  int get sectionTime; // 분
  @override
  String? get startName;
  @override
  String? get endName;
  @override
  String? get displayName; // 예: "5100번 버스 탑승"
  @override
  String? get color; // "#0068B7" 같은 hex
  @override
  String? get busLabel;
  @override
  List<String> get busNumbers;
  @override
  String? get subwayLine;

  /// Create a copy of TransitSegmentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransitSegmentDtoImplCopyWith<_$TransitSegmentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccessibilityGuideDto _$AccessibilityGuideDtoFromJson(
  Map<String, dynamic> json,
) {
  return _AccessibilityGuideDto.fromJson(json);
}

/// @nodoc
mixin _$AccessibilityGuideDto {
  String? get nearestStation => throw _privateConstructorUsedError;
  String? get recommendedExit => throw _privateConstructorUsedError;
  String? get caution => throw _privateConstructorUsedError;

  /// Serializes this AccessibilityGuideDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccessibilityGuideDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccessibilityGuideDtoCopyWith<AccessibilityGuideDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessibilityGuideDtoCopyWith<$Res> {
  factory $AccessibilityGuideDtoCopyWith(
    AccessibilityGuideDto value,
    $Res Function(AccessibilityGuideDto) then,
  ) = _$AccessibilityGuideDtoCopyWithImpl<$Res, AccessibilityGuideDto>;
  @useResult
  $Res call({String? nearestStation, String? recommendedExit, String? caution});
}

/// @nodoc
class _$AccessibilityGuideDtoCopyWithImpl<
  $Res,
  $Val extends AccessibilityGuideDto
>
    implements $AccessibilityGuideDtoCopyWith<$Res> {
  _$AccessibilityGuideDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccessibilityGuideDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nearestStation = freezed,
    Object? recommendedExit = freezed,
    Object? caution = freezed,
  }) {
    return _then(
      _value.copyWith(
            nearestStation: freezed == nearestStation
                ? _value.nearestStation
                : nearestStation // ignore: cast_nullable_to_non_nullable
                      as String?,
            recommendedExit: freezed == recommendedExit
                ? _value.recommendedExit
                : recommendedExit // ignore: cast_nullable_to_non_nullable
                      as String?,
            caution: freezed == caution
                ? _value.caution
                : caution // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccessibilityGuideDtoImplCopyWith<$Res>
    implements $AccessibilityGuideDtoCopyWith<$Res> {
  factory _$$AccessibilityGuideDtoImplCopyWith(
    _$AccessibilityGuideDtoImpl value,
    $Res Function(_$AccessibilityGuideDtoImpl) then,
  ) = __$$AccessibilityGuideDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? nearestStation, String? recommendedExit, String? caution});
}

/// @nodoc
class __$$AccessibilityGuideDtoImplCopyWithImpl<$Res>
    extends
        _$AccessibilityGuideDtoCopyWithImpl<$Res, _$AccessibilityGuideDtoImpl>
    implements _$$AccessibilityGuideDtoImplCopyWith<$Res> {
  __$$AccessibilityGuideDtoImplCopyWithImpl(
    _$AccessibilityGuideDtoImpl _value,
    $Res Function(_$AccessibilityGuideDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccessibilityGuideDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nearestStation = freezed,
    Object? recommendedExit = freezed,
    Object? caution = freezed,
  }) {
    return _then(
      _$AccessibilityGuideDtoImpl(
        nearestStation: freezed == nearestStation
            ? _value.nearestStation
            : nearestStation // ignore: cast_nullable_to_non_nullable
                  as String?,
        recommendedExit: freezed == recommendedExit
            ? _value.recommendedExit
            : recommendedExit // ignore: cast_nullable_to_non_nullable
                  as String?,
        caution: freezed == caution
            ? _value.caution
            : caution // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessibilityGuideDtoImpl implements _AccessibilityGuideDto {
  const _$AccessibilityGuideDtoImpl({
    this.nearestStation,
    this.recommendedExit,
    this.caution,
  });

  factory _$AccessibilityGuideDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessibilityGuideDtoImplFromJson(json);

  @override
  final String? nearestStation;
  @override
  final String? recommendedExit;
  @override
  final String? caution;

  @override
  String toString() {
    return 'AccessibilityGuideDto(nearestStation: $nearestStation, recommendedExit: $recommendedExit, caution: $caution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessibilityGuideDtoImpl &&
            (identical(other.nearestStation, nearestStation) ||
                other.nearestStation == nearestStation) &&
            (identical(other.recommendedExit, recommendedExit) ||
                other.recommendedExit == recommendedExit) &&
            (identical(other.caution, caution) || other.caution == caution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, nearestStation, recommendedExit, caution);

  /// Create a copy of AccessibilityGuideDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessibilityGuideDtoImplCopyWith<_$AccessibilityGuideDtoImpl>
  get copyWith =>
      __$$AccessibilityGuideDtoImplCopyWithImpl<_$AccessibilityGuideDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessibilityGuideDtoImplToJson(this);
  }
}

abstract class _AccessibilityGuideDto implements AccessibilityGuideDto {
  const factory _AccessibilityGuideDto({
    final String? nearestStation,
    final String? recommendedExit,
    final String? caution,
  }) = _$AccessibilityGuideDtoImpl;

  factory _AccessibilityGuideDto.fromJson(Map<String, dynamic> json) =
      _$AccessibilityGuideDtoImpl.fromJson;

  @override
  String? get nearestStation;
  @override
  String? get recommendedExit;
  @override
  String? get caution;

  /// Create a copy of AccessibilityGuideDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccessibilityGuideDtoImplCopyWith<_$AccessibilityGuideDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
