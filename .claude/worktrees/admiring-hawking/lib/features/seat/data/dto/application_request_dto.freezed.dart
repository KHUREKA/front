// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplicationRequestDto _$ApplicationRequestDtoFromJson(
  Map<String, dynamic> json,
) {
  return _ApplicationRequestDto.fromJson(json);
}

/// @nodoc
mixin _$ApplicationRequestDto {
  int get scheduleId => throw _privateConstructorUsedError;
  int get requestedSeatCount => throw _privateConstructorUsedError;
  bool get autoAssign => throw _privateConstructorUsedError;
  int? get priority1SeatZoneId => throw _privateConstructorUsedError;
  int? get priority2SeatZoneId => throw _privateConstructorUsedError;
  int? get priority3SeatZoneId => throw _privateConstructorUsedError;
  bool get autoPaymentAgreed => throw _privateConstructorUsedError;
  String? get seatPreference => throw _privateConstructorUsedError;

  /// Serializes this ApplicationRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationRequestDtoCopyWith<ApplicationRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationRequestDtoCopyWith<$Res> {
  factory $ApplicationRequestDtoCopyWith(
    ApplicationRequestDto value,
    $Res Function(ApplicationRequestDto) then,
  ) = _$ApplicationRequestDtoCopyWithImpl<$Res, ApplicationRequestDto>;
  @useResult
  $Res call({
    int scheduleId,
    int requestedSeatCount,
    bool autoAssign,
    int? priority1SeatZoneId,
    int? priority2SeatZoneId,
    int? priority3SeatZoneId,
    bool autoPaymentAgreed,
    String? seatPreference,
  });
}

/// @nodoc
class _$ApplicationRequestDtoCopyWithImpl<
  $Res,
  $Val extends ApplicationRequestDto
>
    implements $ApplicationRequestDtoCopyWith<$Res> {
  _$ApplicationRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? requestedSeatCount = null,
    Object? autoAssign = null,
    Object? priority1SeatZoneId = freezed,
    Object? priority2SeatZoneId = freezed,
    Object? priority3SeatZoneId = freezed,
    Object? autoPaymentAgreed = null,
    Object? seatPreference = freezed,
  }) {
    return _then(
      _value.copyWith(
            scheduleId: null == scheduleId
                ? _value.scheduleId
                : scheduleId // ignore: cast_nullable_to_non_nullable
                      as int,
            requestedSeatCount: null == requestedSeatCount
                ? _value.requestedSeatCount
                : requestedSeatCount // ignore: cast_nullable_to_non_nullable
                      as int,
            autoAssign: null == autoAssign
                ? _value.autoAssign
                : autoAssign // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority1SeatZoneId: freezed == priority1SeatZoneId
                ? _value.priority1SeatZoneId
                : priority1SeatZoneId // ignore: cast_nullable_to_non_nullable
                      as int?,
            priority2SeatZoneId: freezed == priority2SeatZoneId
                ? _value.priority2SeatZoneId
                : priority2SeatZoneId // ignore: cast_nullable_to_non_nullable
                      as int?,
            priority3SeatZoneId: freezed == priority3SeatZoneId
                ? _value.priority3SeatZoneId
                : priority3SeatZoneId // ignore: cast_nullable_to_non_nullable
                      as int?,
            autoPaymentAgreed: null == autoPaymentAgreed
                ? _value.autoPaymentAgreed
                : autoPaymentAgreed // ignore: cast_nullable_to_non_nullable
                      as bool,
            seatPreference: freezed == seatPreference
                ? _value.seatPreference
                : seatPreference // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationRequestDtoImplCopyWith<$Res>
    implements $ApplicationRequestDtoCopyWith<$Res> {
  factory _$$ApplicationRequestDtoImplCopyWith(
    _$ApplicationRequestDtoImpl value,
    $Res Function(_$ApplicationRequestDtoImpl) then,
  ) = __$$ApplicationRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int scheduleId,
    int requestedSeatCount,
    bool autoAssign,
    int? priority1SeatZoneId,
    int? priority2SeatZoneId,
    int? priority3SeatZoneId,
    bool autoPaymentAgreed,
    String? seatPreference,
  });
}

/// @nodoc
class __$$ApplicationRequestDtoImplCopyWithImpl<$Res>
    extends
        _$ApplicationRequestDtoCopyWithImpl<$Res, _$ApplicationRequestDtoImpl>
    implements _$$ApplicationRequestDtoImplCopyWith<$Res> {
  __$$ApplicationRequestDtoImplCopyWithImpl(
    _$ApplicationRequestDtoImpl _value,
    $Res Function(_$ApplicationRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? requestedSeatCount = null,
    Object? autoAssign = null,
    Object? priority1SeatZoneId = freezed,
    Object? priority2SeatZoneId = freezed,
    Object? priority3SeatZoneId = freezed,
    Object? autoPaymentAgreed = null,
    Object? seatPreference = freezed,
  }) {
    return _then(
      _$ApplicationRequestDtoImpl(
        scheduleId: null == scheduleId
            ? _value.scheduleId
            : scheduleId // ignore: cast_nullable_to_non_nullable
                  as int,
        requestedSeatCount: null == requestedSeatCount
            ? _value.requestedSeatCount
            : requestedSeatCount // ignore: cast_nullable_to_non_nullable
                  as int,
        autoAssign: null == autoAssign
            ? _value.autoAssign
            : autoAssign // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority1SeatZoneId: freezed == priority1SeatZoneId
            ? _value.priority1SeatZoneId
            : priority1SeatZoneId // ignore: cast_nullable_to_non_nullable
                  as int?,
        priority2SeatZoneId: freezed == priority2SeatZoneId
            ? _value.priority2SeatZoneId
            : priority2SeatZoneId // ignore: cast_nullable_to_non_nullable
                  as int?,
        priority3SeatZoneId: freezed == priority3SeatZoneId
            ? _value.priority3SeatZoneId
            : priority3SeatZoneId // ignore: cast_nullable_to_non_nullable
                  as int?,
        autoPaymentAgreed: null == autoPaymentAgreed
            ? _value.autoPaymentAgreed
            : autoPaymentAgreed // ignore: cast_nullable_to_non_nullable
                  as bool,
        seatPreference: freezed == seatPreference
            ? _value.seatPreference
            : seatPreference // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationRequestDtoImpl implements _ApplicationRequestDto {
  const _$ApplicationRequestDtoImpl({
    required this.scheduleId,
    required this.requestedSeatCount,
    required this.autoAssign,
    this.priority1SeatZoneId,
    this.priority2SeatZoneId,
    this.priority3SeatZoneId,
    this.autoPaymentAgreed = true,
    this.seatPreference,
  });

  factory _$ApplicationRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationRequestDtoImplFromJson(json);

  @override
  final int scheduleId;
  @override
  final int requestedSeatCount;
  @override
  final bool autoAssign;
  @override
  final int? priority1SeatZoneId;
  @override
  final int? priority2SeatZoneId;
  @override
  final int? priority3SeatZoneId;
  @override
  @JsonKey()
  final bool autoPaymentAgreed;
  @override
  final String? seatPreference;

  @override
  String toString() {
    return 'ApplicationRequestDto(scheduleId: $scheduleId, requestedSeatCount: $requestedSeatCount, autoAssign: $autoAssign, priority1SeatZoneId: $priority1SeatZoneId, priority2SeatZoneId: $priority2SeatZoneId, priority3SeatZoneId: $priority3SeatZoneId, autoPaymentAgreed: $autoPaymentAgreed, seatPreference: $seatPreference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationRequestDtoImpl &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.requestedSeatCount, requestedSeatCount) ||
                other.requestedSeatCount == requestedSeatCount) &&
            (identical(other.autoAssign, autoAssign) ||
                other.autoAssign == autoAssign) &&
            (identical(other.priority1SeatZoneId, priority1SeatZoneId) ||
                other.priority1SeatZoneId == priority1SeatZoneId) &&
            (identical(other.priority2SeatZoneId, priority2SeatZoneId) ||
                other.priority2SeatZoneId == priority2SeatZoneId) &&
            (identical(other.priority3SeatZoneId, priority3SeatZoneId) ||
                other.priority3SeatZoneId == priority3SeatZoneId) &&
            (identical(other.autoPaymentAgreed, autoPaymentAgreed) ||
                other.autoPaymentAgreed == autoPaymentAgreed) &&
            (identical(other.seatPreference, seatPreference) ||
                other.seatPreference == seatPreference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    scheduleId,
    requestedSeatCount,
    autoAssign,
    priority1SeatZoneId,
    priority2SeatZoneId,
    priority3SeatZoneId,
    autoPaymentAgreed,
    seatPreference,
  );

  /// Create a copy of ApplicationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationRequestDtoImplCopyWith<_$ApplicationRequestDtoImpl>
  get copyWith =>
      __$$ApplicationRequestDtoImplCopyWithImpl<_$ApplicationRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationRequestDtoImplToJson(this);
  }
}

abstract class _ApplicationRequestDto implements ApplicationRequestDto {
  const factory _ApplicationRequestDto({
    required final int scheduleId,
    required final int requestedSeatCount,
    required final bool autoAssign,
    final int? priority1SeatZoneId,
    final int? priority2SeatZoneId,
    final int? priority3SeatZoneId,
    final bool autoPaymentAgreed,
    final String? seatPreference,
  }) = _$ApplicationRequestDtoImpl;

  factory _ApplicationRequestDto.fromJson(Map<String, dynamic> json) =
      _$ApplicationRequestDtoImpl.fromJson;

  @override
  int get scheduleId;
  @override
  int get requestedSeatCount;
  @override
  bool get autoAssign;
  @override
  int? get priority1SeatZoneId;
  @override
  int? get priority2SeatZoneId;
  @override
  int? get priority3SeatZoneId;
  @override
  bool get autoPaymentAgreed;
  @override
  String? get seatPreference;

  /// Create a copy of ApplicationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationRequestDtoImplCopyWith<_$ApplicationRequestDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
