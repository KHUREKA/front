// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mypage_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MyPageProfileDto _$MyPageProfileDtoFromJson(Map<String, dynamic> json) {
  return _MyPageProfileDto.fromJson(json);
}

/// @nodoc
mixin _$MyPageProfileDto {
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  SeatPreference? get seatPreference => throw _privateConstructorUsedError;

  /// Serializes this MyPageProfileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyPageProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyPageProfileDtoCopyWith<MyPageProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyPageProfileDtoCopyWith<$Res> {
  factory $MyPageProfileDtoCopyWith(
    MyPageProfileDto value,
    $Res Function(MyPageProfileDto) then,
  ) = _$MyPageProfileDtoCopyWithImpl<$Res, MyPageProfileDto>;
  @useResult
  $Res call({
    String email,
    String username,
    String? phone,
    SeatPreference? seatPreference,
  });
}

/// @nodoc
class _$MyPageProfileDtoCopyWithImpl<$Res, $Val extends MyPageProfileDto>
    implements $MyPageProfileDtoCopyWith<$Res> {
  _$MyPageProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyPageProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? username = null,
    Object? phone = freezed,
    Object? seatPreference = freezed,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            seatPreference: freezed == seatPreference
                ? _value.seatPreference
                : seatPreference // ignore: cast_nullable_to_non_nullable
                      as SeatPreference?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MyPageProfileDtoImplCopyWith<$Res>
    implements $MyPageProfileDtoCopyWith<$Res> {
  factory _$$MyPageProfileDtoImplCopyWith(
    _$MyPageProfileDtoImpl value,
    $Res Function(_$MyPageProfileDtoImpl) then,
  ) = __$$MyPageProfileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String email,
    String username,
    String? phone,
    SeatPreference? seatPreference,
  });
}

/// @nodoc
class __$$MyPageProfileDtoImplCopyWithImpl<$Res>
    extends _$MyPageProfileDtoCopyWithImpl<$Res, _$MyPageProfileDtoImpl>
    implements _$$MyPageProfileDtoImplCopyWith<$Res> {
  __$$MyPageProfileDtoImplCopyWithImpl(
    _$MyPageProfileDtoImpl _value,
    $Res Function(_$MyPageProfileDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MyPageProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? username = null,
    Object? phone = freezed,
    Object? seatPreference = freezed,
  }) {
    return _then(
      _$MyPageProfileDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        seatPreference: freezed == seatPreference
            ? _value.seatPreference
            : seatPreference // ignore: cast_nullable_to_non_nullable
                  as SeatPreference?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MyPageProfileDtoImpl implements _MyPageProfileDto {
  const _$MyPageProfileDtoImpl({
    required this.email,
    required this.username,
    this.phone,
    this.seatPreference,
  });

  factory _$MyPageProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyPageProfileDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String username;
  @override
  final String? phone;
  @override
  final SeatPreference? seatPreference;

  @override
  String toString() {
    return 'MyPageProfileDto(email: $email, username: $username, phone: $phone, seatPreference: $seatPreference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyPageProfileDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.seatPreference, seatPreference) ||
                other.seatPreference == seatPreference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, username, phone, seatPreference);

  /// Create a copy of MyPageProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyPageProfileDtoImplCopyWith<_$MyPageProfileDtoImpl> get copyWith =>
      __$$MyPageProfileDtoImplCopyWithImpl<_$MyPageProfileDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MyPageProfileDtoImplToJson(this);
  }
}

abstract class _MyPageProfileDto implements MyPageProfileDto {
  const factory _MyPageProfileDto({
    required final String email,
    required final String username,
    final String? phone,
    final SeatPreference? seatPreference,
  }) = _$MyPageProfileDtoImpl;

  factory _MyPageProfileDto.fromJson(Map<String, dynamic> json) =
      _$MyPageProfileDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get username;
  @override
  String? get phone;
  @override
  SeatPreference? get seatPreference;

  /// Create a copy of MyPageProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyPageProfileDtoImplCopyWith<_$MyPageProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
