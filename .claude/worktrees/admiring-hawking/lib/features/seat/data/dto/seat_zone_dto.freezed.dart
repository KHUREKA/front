// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seat_zone_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SeatZoneDto _$SeatZoneDtoFromJson(Map<String, dynamic> json) {
  return _SeatZoneDto.fromJson(json);
}

/// @nodoc
mixin _$SeatZoneDto {
  int get id => throw _privateConstructorUsedError;
  int get scheduleId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  int get availableSeats => throw _privateConstructorUsedError;

  /// Serializes this SeatZoneDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeatZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeatZoneDtoCopyWith<SeatZoneDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeatZoneDtoCopyWith<$Res> {
  factory $SeatZoneDtoCopyWith(
    SeatZoneDto value,
    $Res Function(SeatZoneDto) then,
  ) = _$SeatZoneDtoCopyWithImpl<$Res, SeatZoneDto>;
  @useResult
  $Res call({
    int id,
    int scheduleId,
    String name,
    int price,
    int availableSeats,
  });
}

/// @nodoc
class _$SeatZoneDtoCopyWithImpl<$Res, $Val extends SeatZoneDto>
    implements $SeatZoneDtoCopyWith<$Res> {
  _$SeatZoneDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeatZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scheduleId = null,
    Object? name = null,
    Object? price = null,
    Object? availableSeats = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            scheduleId: null == scheduleId
                ? _value.scheduleId
                : scheduleId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            availableSeats: null == availableSeats
                ? _value.availableSeats
                : availableSeats // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeatZoneDtoImplCopyWith<$Res>
    implements $SeatZoneDtoCopyWith<$Res> {
  factory _$$SeatZoneDtoImplCopyWith(
    _$SeatZoneDtoImpl value,
    $Res Function(_$SeatZoneDtoImpl) then,
  ) = __$$SeatZoneDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int scheduleId,
    String name,
    int price,
    int availableSeats,
  });
}

/// @nodoc
class __$$SeatZoneDtoImplCopyWithImpl<$Res>
    extends _$SeatZoneDtoCopyWithImpl<$Res, _$SeatZoneDtoImpl>
    implements _$$SeatZoneDtoImplCopyWith<$Res> {
  __$$SeatZoneDtoImplCopyWithImpl(
    _$SeatZoneDtoImpl _value,
    $Res Function(_$SeatZoneDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SeatZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scheduleId = null,
    Object? name = null,
    Object? price = null,
    Object? availableSeats = null,
  }) {
    return _then(
      _$SeatZoneDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        scheduleId: null == scheduleId
            ? _value.scheduleId
            : scheduleId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        availableSeats: null == availableSeats
            ? _value.availableSeats
            : availableSeats // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeatZoneDtoImpl extends _SeatZoneDto {
  const _$SeatZoneDtoImpl({
    required this.id,
    required this.scheduleId,
    required this.name,
    required this.price,
    this.availableSeats = 0,
  }) : super._();

  factory _$SeatZoneDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeatZoneDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int scheduleId;
  @override
  final String name;
  @override
  final int price;
  @override
  @JsonKey()
  final int availableSeats;

  @override
  String toString() {
    return 'SeatZoneDto(id: $id, scheduleId: $scheduleId, name: $name, price: $price, availableSeats: $availableSeats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeatZoneDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.availableSeats, availableSeats) ||
                other.availableSeats == availableSeats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, scheduleId, name, price, availableSeats);

  /// Create a copy of SeatZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeatZoneDtoImplCopyWith<_$SeatZoneDtoImpl> get copyWith =>
      __$$SeatZoneDtoImplCopyWithImpl<_$SeatZoneDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeatZoneDtoImplToJson(this);
  }
}

abstract class _SeatZoneDto extends SeatZoneDto {
  const factory _SeatZoneDto({
    required final int id,
    required final int scheduleId,
    required final String name,
    required final int price,
    final int availableSeats,
  }) = _$SeatZoneDtoImpl;
  const _SeatZoneDto._() : super._();

  factory _SeatZoneDto.fromJson(Map<String, dynamic> json) =
      _$SeatZoneDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get scheduleId;
  @override
  String get name;
  @override
  int get price;
  @override
  int get availableSeats;

  /// Create a copy of SeatZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeatZoneDtoImplCopyWith<_$SeatZoneDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
