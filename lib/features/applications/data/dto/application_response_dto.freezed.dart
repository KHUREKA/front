// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplicationResponseDto _$ApplicationResponseDtoFromJson(
  Map<String, dynamic> json,
) {
  return _ApplicationResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ApplicationResponseDto {
  int get id => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // APPLIED | LOSE | TICKET_ISSUED | CANCELLED
  int get requestedSeatCount => throw _privateConstructorUsedError;
  bool get autoAssign => throw _privateConstructorUsedError;
  String get appliedAt =>
      throw _privateConstructorUsedError; // ISO LocalDateTime
  String? get lotteryResultAt => throw _privateConstructorUsedError;
  String? get paidAt => throw _privateConstructorUsedError;
  String? get applicationCode => throw _privateConstructorUsedError;
  int? get eventId =>
      throw _privateConstructorUsedError; // 백엔드 추후 추가 예정 — 지도 페이지 이동에 사용
  String get eventTitle => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String get startTime =>
      throw _privateConstructorUsedError; // ISO LocalDateTime
  String get lotteryAt =>
      throw _privateConstructorUsedError; // ISO LocalDateTime
  String? get priority1ZoneName => throw _privateConstructorUsedError;
  String? get priority2ZoneName => throw _privateConstructorUsedError;
  String? get priority3ZoneName => throw _privateConstructorUsedError;
  String? get assignedZoneName => throw _privateConstructorUsedError;
  String? get mockPaymentStatus => throw _privateConstructorUsedError;

  /// Serializes this ApplicationResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationResponseDtoCopyWith<ApplicationResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationResponseDtoCopyWith<$Res> {
  factory $ApplicationResponseDtoCopyWith(
    ApplicationResponseDto value,
    $Res Function(ApplicationResponseDto) then,
  ) = _$ApplicationResponseDtoCopyWithImpl<$Res, ApplicationResponseDto>;
  @useResult
  $Res call({
    int id,
    String status,
    int requestedSeatCount,
    bool autoAssign,
    String appliedAt,
    String? lotteryResultAt,
    String? paidAt,
    String? applicationCode,
    int? eventId,
    String eventTitle,
    String venueName,
    String startTime,
    String lotteryAt,
    String? priority1ZoneName,
    String? priority2ZoneName,
    String? priority3ZoneName,
    String? assignedZoneName,
    String? mockPaymentStatus,
  });
}

/// @nodoc
class _$ApplicationResponseDtoCopyWithImpl<
  $Res,
  $Val extends ApplicationResponseDto
>
    implements $ApplicationResponseDtoCopyWith<$Res> {
  _$ApplicationResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? requestedSeatCount = null,
    Object? autoAssign = null,
    Object? appliedAt = null,
    Object? lotteryResultAt = freezed,
    Object? paidAt = freezed,
    Object? applicationCode = freezed,
    Object? eventId = freezed,
    Object? eventTitle = null,
    Object? venueName = null,
    Object? startTime = null,
    Object? lotteryAt = null,
    Object? priority1ZoneName = freezed,
    Object? priority2ZoneName = freezed,
    Object? priority3ZoneName = freezed,
    Object? assignedZoneName = freezed,
    Object? mockPaymentStatus = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            requestedSeatCount: null == requestedSeatCount
                ? _value.requestedSeatCount
                : requestedSeatCount // ignore: cast_nullable_to_non_nullable
                      as int,
            autoAssign: null == autoAssign
                ? _value.autoAssign
                : autoAssign // ignore: cast_nullable_to_non_nullable
                      as bool,
            appliedAt: null == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            lotteryResultAt: freezed == lotteryResultAt
                ? _value.lotteryResultAt
                : lotteryResultAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            applicationCode: freezed == applicationCode
                ? _value.applicationCode
                : applicationCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventId: freezed == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as int?,
            eventTitle: null == eventTitle
                ? _value.eventTitle
                : eventTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            venueName: null == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            lotteryAt: null == lotteryAt
                ? _value.lotteryAt
                : lotteryAt // ignore: cast_nullable_to_non_nullable
                      as String,
            priority1ZoneName: freezed == priority1ZoneName
                ? _value.priority1ZoneName
                : priority1ZoneName // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority2ZoneName: freezed == priority2ZoneName
                ? _value.priority2ZoneName
                : priority2ZoneName // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority3ZoneName: freezed == priority3ZoneName
                ? _value.priority3ZoneName
                : priority3ZoneName // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedZoneName: freezed == assignedZoneName
                ? _value.assignedZoneName
                : assignedZoneName // ignore: cast_nullable_to_non_nullable
                      as String?,
            mockPaymentStatus: freezed == mockPaymentStatus
                ? _value.mockPaymentStatus
                : mockPaymentStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationResponseDtoImplCopyWith<$Res>
    implements $ApplicationResponseDtoCopyWith<$Res> {
  factory _$$ApplicationResponseDtoImplCopyWith(
    _$ApplicationResponseDtoImpl value,
    $Res Function(_$ApplicationResponseDtoImpl) then,
  ) = __$$ApplicationResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String status,
    int requestedSeatCount,
    bool autoAssign,
    String appliedAt,
    String? lotteryResultAt,
    String? paidAt,
    String? applicationCode,
    int? eventId,
    String eventTitle,
    String venueName,
    String startTime,
    String lotteryAt,
    String? priority1ZoneName,
    String? priority2ZoneName,
    String? priority3ZoneName,
    String? assignedZoneName,
    String? mockPaymentStatus,
  });
}

/// @nodoc
class __$$ApplicationResponseDtoImplCopyWithImpl<$Res>
    extends
        _$ApplicationResponseDtoCopyWithImpl<$Res, _$ApplicationResponseDtoImpl>
    implements _$$ApplicationResponseDtoImplCopyWith<$Res> {
  __$$ApplicationResponseDtoImplCopyWithImpl(
    _$ApplicationResponseDtoImpl _value,
    $Res Function(_$ApplicationResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? requestedSeatCount = null,
    Object? autoAssign = null,
    Object? appliedAt = null,
    Object? lotteryResultAt = freezed,
    Object? paidAt = freezed,
    Object? applicationCode = freezed,
    Object? eventId = freezed,
    Object? eventTitle = null,
    Object? venueName = null,
    Object? startTime = null,
    Object? lotteryAt = null,
    Object? priority1ZoneName = freezed,
    Object? priority2ZoneName = freezed,
    Object? priority3ZoneName = freezed,
    Object? assignedZoneName = freezed,
    Object? mockPaymentStatus = freezed,
  }) {
    return _then(
      _$ApplicationResponseDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        requestedSeatCount: null == requestedSeatCount
            ? _value.requestedSeatCount
            : requestedSeatCount // ignore: cast_nullable_to_non_nullable
                  as int,
        autoAssign: null == autoAssign
            ? _value.autoAssign
            : autoAssign // ignore: cast_nullable_to_non_nullable
                  as bool,
        appliedAt: null == appliedAt
            ? _value.appliedAt
            : appliedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        lotteryResultAt: freezed == lotteryResultAt
            ? _value.lotteryResultAt
            : lotteryResultAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        applicationCode: freezed == applicationCode
            ? _value.applicationCode
            : applicationCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventId: freezed == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as int?,
        eventTitle: null == eventTitle
            ? _value.eventTitle
            : eventTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        venueName: null == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        lotteryAt: null == lotteryAt
            ? _value.lotteryAt
            : lotteryAt // ignore: cast_nullable_to_non_nullable
                  as String,
        priority1ZoneName: freezed == priority1ZoneName
            ? _value.priority1ZoneName
            : priority1ZoneName // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority2ZoneName: freezed == priority2ZoneName
            ? _value.priority2ZoneName
            : priority2ZoneName // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority3ZoneName: freezed == priority3ZoneName
            ? _value.priority3ZoneName
            : priority3ZoneName // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedZoneName: freezed == assignedZoneName
            ? _value.assignedZoneName
            : assignedZoneName // ignore: cast_nullable_to_non_nullable
                  as String?,
        mockPaymentStatus: freezed == mockPaymentStatus
            ? _value.mockPaymentStatus
            : mockPaymentStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationResponseDtoImpl implements _ApplicationResponseDto {
  const _$ApplicationResponseDtoImpl({
    required this.id,
    required this.status,
    required this.requestedSeatCount,
    required this.autoAssign,
    required this.appliedAt,
    this.lotteryResultAt,
    this.paidAt,
    this.applicationCode,
    this.eventId,
    required this.eventTitle,
    required this.venueName,
    required this.startTime,
    required this.lotteryAt,
    this.priority1ZoneName,
    this.priority2ZoneName,
    this.priority3ZoneName,
    this.assignedZoneName,
    this.mockPaymentStatus,
  });

  factory _$ApplicationResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationResponseDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String status;
  // APPLIED | LOSE | TICKET_ISSUED | CANCELLED
  @override
  final int requestedSeatCount;
  @override
  final bool autoAssign;
  @override
  final String appliedAt;
  // ISO LocalDateTime
  @override
  final String? lotteryResultAt;
  @override
  final String? paidAt;
  @override
  final String? applicationCode;
  @override
  final int? eventId;
  // 백엔드 추후 추가 예정 — 지도 페이지 이동에 사용
  @override
  final String eventTitle;
  @override
  final String venueName;
  @override
  final String startTime;
  // ISO LocalDateTime
  @override
  final String lotteryAt;
  // ISO LocalDateTime
  @override
  final String? priority1ZoneName;
  @override
  final String? priority2ZoneName;
  @override
  final String? priority3ZoneName;
  @override
  final String? assignedZoneName;
  @override
  final String? mockPaymentStatus;

  @override
  String toString() {
    return 'ApplicationResponseDto(id: $id, status: $status, requestedSeatCount: $requestedSeatCount, autoAssign: $autoAssign, appliedAt: $appliedAt, lotteryResultAt: $lotteryResultAt, paidAt: $paidAt, applicationCode: $applicationCode, eventId: $eventId, eventTitle: $eventTitle, venueName: $venueName, startTime: $startTime, lotteryAt: $lotteryAt, priority1ZoneName: $priority1ZoneName, priority2ZoneName: $priority2ZoneName, priority3ZoneName: $priority3ZoneName, assignedZoneName: $assignedZoneName, mockPaymentStatus: $mockPaymentStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationResponseDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedSeatCount, requestedSeatCount) ||
                other.requestedSeatCount == requestedSeatCount) &&
            (identical(other.autoAssign, autoAssign) ||
                other.autoAssign == autoAssign) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.lotteryResultAt, lotteryResultAt) ||
                other.lotteryResultAt == lotteryResultAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.applicationCode, applicationCode) ||
                other.applicationCode == applicationCode) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.lotteryAt, lotteryAt) ||
                other.lotteryAt == lotteryAt) &&
            (identical(other.priority1ZoneName, priority1ZoneName) ||
                other.priority1ZoneName == priority1ZoneName) &&
            (identical(other.priority2ZoneName, priority2ZoneName) ||
                other.priority2ZoneName == priority2ZoneName) &&
            (identical(other.priority3ZoneName, priority3ZoneName) ||
                other.priority3ZoneName == priority3ZoneName) &&
            (identical(other.assignedZoneName, assignedZoneName) ||
                other.assignedZoneName == assignedZoneName) &&
            (identical(other.mockPaymentStatus, mockPaymentStatus) ||
                other.mockPaymentStatus == mockPaymentStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    status,
    requestedSeatCount,
    autoAssign,
    appliedAt,
    lotteryResultAt,
    paidAt,
    applicationCode,
    eventId,
    eventTitle,
    venueName,
    startTime,
    lotteryAt,
    priority1ZoneName,
    priority2ZoneName,
    priority3ZoneName,
    assignedZoneName,
    mockPaymentStatus,
  );

  /// Create a copy of ApplicationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationResponseDtoImplCopyWith<_$ApplicationResponseDtoImpl>
  get copyWith =>
      __$$ApplicationResponseDtoImplCopyWithImpl<_$ApplicationResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationResponseDtoImplToJson(this);
  }
}

abstract class _ApplicationResponseDto implements ApplicationResponseDto {
  const factory _ApplicationResponseDto({
    required final int id,
    required final String status,
    required final int requestedSeatCount,
    required final bool autoAssign,
    required final String appliedAt,
    final String? lotteryResultAt,
    final String? paidAt,
    final String? applicationCode,
    final int? eventId,
    required final String eventTitle,
    required final String venueName,
    required final String startTime,
    required final String lotteryAt,
    final String? priority1ZoneName,
    final String? priority2ZoneName,
    final String? priority3ZoneName,
    final String? assignedZoneName,
    final String? mockPaymentStatus,
  }) = _$ApplicationResponseDtoImpl;

  factory _ApplicationResponseDto.fromJson(Map<String, dynamic> json) =
      _$ApplicationResponseDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get status; // APPLIED | LOSE | TICKET_ISSUED | CANCELLED
  @override
  int get requestedSeatCount;
  @override
  bool get autoAssign;
  @override
  String get appliedAt; // ISO LocalDateTime
  @override
  String? get lotteryResultAt;
  @override
  String? get paidAt;
  @override
  String? get applicationCode;
  @override
  int? get eventId; // 백엔드 추후 추가 예정 — 지도 페이지 이동에 사용
  @override
  String get eventTitle;
  @override
  String get venueName;
  @override
  String get startTime; // ISO LocalDateTime
  @override
  String get lotteryAt; // ISO LocalDateTime
  @override
  String? get priority1ZoneName;
  @override
  String? get priority2ZoneName;
  @override
  String? get priority3ZoneName;
  @override
  String? get assignedZoneName;
  @override
  String? get mockPaymentStatus;

  /// Create a copy of ApplicationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationResponseDtoImplCopyWith<_$ApplicationResponseDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
