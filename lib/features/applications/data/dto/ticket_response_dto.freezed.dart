// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AssignedSeatInfoDto _$AssignedSeatInfoDtoFromJson(Map<String, dynamic> json) {
  return _AssignedSeatInfoDto.fromJson(json);
}

/// @nodoc
mixin _$AssignedSeatInfoDto {
  String get rowLabel => throw _privateConstructorUsedError;
  String get seatNumber => throw _privateConstructorUsedError;
  String get ticketCode => throw _privateConstructorUsedError;

  /// Serializes this AssignedSeatInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignedSeatInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignedSeatInfoDtoCopyWith<AssignedSeatInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignedSeatInfoDtoCopyWith<$Res> {
  factory $AssignedSeatInfoDtoCopyWith(
    AssignedSeatInfoDto value,
    $Res Function(AssignedSeatInfoDto) then,
  ) = _$AssignedSeatInfoDtoCopyWithImpl<$Res, AssignedSeatInfoDto>;
  @useResult
  $Res call({String rowLabel, String seatNumber, String ticketCode});
}

/// @nodoc
class _$AssignedSeatInfoDtoCopyWithImpl<$Res, $Val extends AssignedSeatInfoDto>
    implements $AssignedSeatInfoDtoCopyWith<$Res> {
  _$AssignedSeatInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignedSeatInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rowLabel = null,
    Object? seatNumber = null,
    Object? ticketCode = null,
  }) {
    return _then(
      _value.copyWith(
            rowLabel: null == rowLabel
                ? _value.rowLabel
                : rowLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            seatNumber: null == seatNumber
                ? _value.seatNumber
                : seatNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            ticketCode: null == ticketCode
                ? _value.ticketCode
                : ticketCode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssignedSeatInfoDtoImplCopyWith<$Res>
    implements $AssignedSeatInfoDtoCopyWith<$Res> {
  factory _$$AssignedSeatInfoDtoImplCopyWith(
    _$AssignedSeatInfoDtoImpl value,
    $Res Function(_$AssignedSeatInfoDtoImpl) then,
  ) = __$$AssignedSeatInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String rowLabel, String seatNumber, String ticketCode});
}

/// @nodoc
class __$$AssignedSeatInfoDtoImplCopyWithImpl<$Res>
    extends _$AssignedSeatInfoDtoCopyWithImpl<$Res, _$AssignedSeatInfoDtoImpl>
    implements _$$AssignedSeatInfoDtoImplCopyWith<$Res> {
  __$$AssignedSeatInfoDtoImplCopyWithImpl(
    _$AssignedSeatInfoDtoImpl _value,
    $Res Function(_$AssignedSeatInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssignedSeatInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rowLabel = null,
    Object? seatNumber = null,
    Object? ticketCode = null,
  }) {
    return _then(
      _$AssignedSeatInfoDtoImpl(
        rowLabel: null == rowLabel
            ? _value.rowLabel
            : rowLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        seatNumber: null == seatNumber
            ? _value.seatNumber
            : seatNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        ticketCode: null == ticketCode
            ? _value.ticketCode
            : ticketCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignedSeatInfoDtoImpl implements _AssignedSeatInfoDto {
  const _$AssignedSeatInfoDtoImpl({
    required this.rowLabel,
    required this.seatNumber,
    required this.ticketCode,
  });

  factory _$AssignedSeatInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignedSeatInfoDtoImplFromJson(json);

  @override
  final String rowLabel;
  @override
  final String seatNumber;
  @override
  final String ticketCode;

  @override
  String toString() {
    return 'AssignedSeatInfoDto(rowLabel: $rowLabel, seatNumber: $seatNumber, ticketCode: $ticketCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignedSeatInfoDtoImpl &&
            (identical(other.rowLabel, rowLabel) ||
                other.rowLabel == rowLabel) &&
            (identical(other.seatNumber, seatNumber) ||
                other.seatNumber == seatNumber) &&
            (identical(other.ticketCode, ticketCode) ||
                other.ticketCode == ticketCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, rowLabel, seatNumber, ticketCode);

  /// Create a copy of AssignedSeatInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignedSeatInfoDtoImplCopyWith<_$AssignedSeatInfoDtoImpl> get copyWith =>
      __$$AssignedSeatInfoDtoImplCopyWithImpl<_$AssignedSeatInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignedSeatInfoDtoImplToJson(this);
  }
}

abstract class _AssignedSeatInfoDto implements AssignedSeatInfoDto {
  const factory _AssignedSeatInfoDto({
    required final String rowLabel,
    required final String seatNumber,
    required final String ticketCode,
  }) = _$AssignedSeatInfoDtoImpl;

  factory _AssignedSeatInfoDto.fromJson(Map<String, dynamic> json) =
      _$AssignedSeatInfoDtoImpl.fromJson;

  @override
  String get rowLabel;
  @override
  String get seatNumber;
  @override
  String get ticketCode;

  /// Create a copy of AssignedSeatInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignedSeatInfoDtoImplCopyWith<_$AssignedSeatInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketResponseDto _$TicketResponseDtoFromJson(Map<String, dynamic> json) {
  return _TicketResponseDto.fromJson(json);
}

/// @nodoc
mixin _$TicketResponseDto {
  int get applicationId => throw _privateConstructorUsedError;
  String get applicationCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get paidAt => throw _privateConstructorUsedError;
  String get eventTitle => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String? get venueAddress => throw _privateConstructorUsedError;
  double? get destinationLatitude => throw _privateConstructorUsedError;
  double? get destinationLongitude => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String? get assignedZoneName => throw _privateConstructorUsedError;
  int? get zonePrice => throw _privateConstructorUsedError;
  List<AssignedSeatInfoDto> get seats => throw _privateConstructorUsedError;

  /// Serializes this TicketResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketResponseDtoCopyWith<TicketResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketResponseDtoCopyWith<$Res> {
  factory $TicketResponseDtoCopyWith(
    TicketResponseDto value,
    $Res Function(TicketResponseDto) then,
  ) = _$TicketResponseDtoCopyWithImpl<$Res, TicketResponseDto>;
  @useResult
  $Res call({
    int applicationId,
    String applicationCode,
    String status,
    String? paidAt,
    String eventTitle,
    String venueName,
    String? venueAddress,
    double? destinationLatitude,
    double? destinationLongitude,
    String startTime,
    String? assignedZoneName,
    int? zonePrice,
    List<AssignedSeatInfoDto> seats,
  });
}

/// @nodoc
class _$TicketResponseDtoCopyWithImpl<$Res, $Val extends TicketResponseDto>
    implements $TicketResponseDtoCopyWith<$Res> {
  _$TicketResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? applicationCode = null,
    Object? status = null,
    Object? paidAt = freezed,
    Object? eventTitle = null,
    Object? venueName = null,
    Object? venueAddress = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? startTime = null,
    Object? assignedZoneName = freezed,
    Object? zonePrice = freezed,
    Object? seats = null,
  }) {
    return _then(
      _value.copyWith(
            applicationId: null == applicationId
                ? _value.applicationId
                : applicationId // ignore: cast_nullable_to_non_nullable
                      as int,
            applicationCode: null == applicationCode
                ? _value.applicationCode
                : applicationCode // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            destinationLatitude: freezed == destinationLatitude
                ? _value.destinationLatitude
                : destinationLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            destinationLongitude: freezed == destinationLongitude
                ? _value.destinationLongitude
                : destinationLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedZoneName: freezed == assignedZoneName
                ? _value.assignedZoneName
                : assignedZoneName // ignore: cast_nullable_to_non_nullable
                      as String?,
            zonePrice: freezed == zonePrice
                ? _value.zonePrice
                : zonePrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            seats: null == seats
                ? _value.seats
                : seats // ignore: cast_nullable_to_non_nullable
                      as List<AssignedSeatInfoDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TicketResponseDtoImplCopyWith<$Res>
    implements $TicketResponseDtoCopyWith<$Res> {
  factory _$$TicketResponseDtoImplCopyWith(
    _$TicketResponseDtoImpl value,
    $Res Function(_$TicketResponseDtoImpl) then,
  ) = __$$TicketResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int applicationId,
    String applicationCode,
    String status,
    String? paidAt,
    String eventTitle,
    String venueName,
    String? venueAddress,
    double? destinationLatitude,
    double? destinationLongitude,
    String startTime,
    String? assignedZoneName,
    int? zonePrice,
    List<AssignedSeatInfoDto> seats,
  });
}

/// @nodoc
class __$$TicketResponseDtoImplCopyWithImpl<$Res>
    extends _$TicketResponseDtoCopyWithImpl<$Res, _$TicketResponseDtoImpl>
    implements _$$TicketResponseDtoImplCopyWith<$Res> {
  __$$TicketResponseDtoImplCopyWithImpl(
    _$TicketResponseDtoImpl _value,
    $Res Function(_$TicketResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TicketResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? applicationCode = null,
    Object? status = null,
    Object? paidAt = freezed,
    Object? eventTitle = null,
    Object? venueName = null,
    Object? venueAddress = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? startTime = null,
    Object? assignedZoneName = freezed,
    Object? zonePrice = freezed,
    Object? seats = null,
  }) {
    return _then(
      _$TicketResponseDtoImpl(
        applicationId: null == applicationId
            ? _value.applicationId
            : applicationId // ignore: cast_nullable_to_non_nullable
                  as int,
        applicationCode: null == applicationCode
            ? _value.applicationCode
            : applicationCode // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        destinationLatitude: freezed == destinationLatitude
            ? _value.destinationLatitude
            : destinationLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        destinationLongitude: freezed == destinationLongitude
            ? _value.destinationLongitude
            : destinationLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedZoneName: freezed == assignedZoneName
            ? _value.assignedZoneName
            : assignedZoneName // ignore: cast_nullable_to_non_nullable
                  as String?,
        zonePrice: freezed == zonePrice
            ? _value.zonePrice
            : zonePrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        seats: null == seats
            ? _value._seats
            : seats // ignore: cast_nullable_to_non_nullable
                  as List<AssignedSeatInfoDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketResponseDtoImpl implements _TicketResponseDto {
  const _$TicketResponseDtoImpl({
    required this.applicationId,
    required this.applicationCode,
    required this.status,
    this.paidAt,
    required this.eventTitle,
    required this.venueName,
    this.venueAddress,
    this.destinationLatitude,
    this.destinationLongitude,
    required this.startTime,
    this.assignedZoneName,
    this.zonePrice,
    final List<AssignedSeatInfoDto> seats = const <AssignedSeatInfoDto>[],
  }) : _seats = seats;

  factory _$TicketResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketResponseDtoImplFromJson(json);

  @override
  final int applicationId;
  @override
  final String applicationCode;
  @override
  final String status;
  @override
  final String? paidAt;
  @override
  final String eventTitle;
  @override
  final String venueName;
  @override
  final String? venueAddress;
  @override
  final double? destinationLatitude;
  @override
  final double? destinationLongitude;
  @override
  final String startTime;
  @override
  final String? assignedZoneName;
  @override
  final int? zonePrice;
  final List<AssignedSeatInfoDto> _seats;
  @override
  @JsonKey()
  List<AssignedSeatInfoDto> get seats {
    if (_seats is EqualUnmodifiableListView) return _seats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_seats);
  }

  @override
  String toString() {
    return 'TicketResponseDto(applicationId: $applicationId, applicationCode: $applicationCode, status: $status, paidAt: $paidAt, eventTitle: $eventTitle, venueName: $venueName, venueAddress: $venueAddress, destinationLatitude: $destinationLatitude, destinationLongitude: $destinationLongitude, startTime: $startTime, assignedZoneName: $assignedZoneName, zonePrice: $zonePrice, seats: $seats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketResponseDtoImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.applicationCode, applicationCode) ||
                other.applicationCode == applicationCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            (identical(other.destinationLatitude, destinationLatitude) ||
                other.destinationLatitude == destinationLatitude) &&
            (identical(other.destinationLongitude, destinationLongitude) ||
                other.destinationLongitude == destinationLongitude) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.assignedZoneName, assignedZoneName) ||
                other.assignedZoneName == assignedZoneName) &&
            (identical(other.zonePrice, zonePrice) ||
                other.zonePrice == zonePrice) &&
            const DeepCollectionEquality().equals(other._seats, _seats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    applicationId,
    applicationCode,
    status,
    paidAt,
    eventTitle,
    venueName,
    venueAddress,
    destinationLatitude,
    destinationLongitude,
    startTime,
    assignedZoneName,
    zonePrice,
    const DeepCollectionEquality().hash(_seats),
  );

  /// Create a copy of TicketResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketResponseDtoImplCopyWith<_$TicketResponseDtoImpl> get copyWith =>
      __$$TicketResponseDtoImplCopyWithImpl<_$TicketResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketResponseDtoImplToJson(this);
  }
}

abstract class _TicketResponseDto implements TicketResponseDto {
  const factory _TicketResponseDto({
    required final int applicationId,
    required final String applicationCode,
    required final String status,
    final String? paidAt,
    required final String eventTitle,
    required final String venueName,
    final String? venueAddress,
    final double? destinationLatitude,
    final double? destinationLongitude,
    required final String startTime,
    final String? assignedZoneName,
    final int? zonePrice,
    final List<AssignedSeatInfoDto> seats,
  }) = _$TicketResponseDtoImpl;

  factory _TicketResponseDto.fromJson(Map<String, dynamic> json) =
      _$TicketResponseDtoImpl.fromJson;

  @override
  int get applicationId;
  @override
  String get applicationCode;
  @override
  String get status;
  @override
  String? get paidAt;
  @override
  String get eventTitle;
  @override
  String get venueName;
  @override
  String? get venueAddress;
  @override
  double? get destinationLatitude;
  @override
  double? get destinationLongitude;
  @override
  String get startTime;
  @override
  String? get assignedZoneName;
  @override
  int? get zonePrice;
  @override
  List<AssignedSeatInfoDto> get seats;

  /// Create a copy of TicketResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketResponseDtoImplCopyWith<_$TicketResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
