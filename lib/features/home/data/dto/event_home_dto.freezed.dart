// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_home_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventHomeDto _$EventHomeDtoFromJson(Map<String, dynamic> json) {
  return _EventHomeDto.fromJson(json);
}

/// @nodoc
mixin _$EventHomeDto {
  List<EventSummaryDto> get nearbyEvents => throw _privateConstructorUsedError;
  List<EventSummaryDto> get recommendedEvents =>
      throw _privateConstructorUsedError;

  /// Serializes this EventHomeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventHomeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventHomeDtoCopyWith<EventHomeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventHomeDtoCopyWith<$Res> {
  factory $EventHomeDtoCopyWith(
    EventHomeDto value,
    $Res Function(EventHomeDto) then,
  ) = _$EventHomeDtoCopyWithImpl<$Res, EventHomeDto>;
  @useResult
  $Res call({
    List<EventSummaryDto> nearbyEvents,
    List<EventSummaryDto> recommendedEvents,
  });
}

/// @nodoc
class _$EventHomeDtoCopyWithImpl<$Res, $Val extends EventHomeDto>
    implements $EventHomeDtoCopyWith<$Res> {
  _$EventHomeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventHomeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nearbyEvents = null, Object? recommendedEvents = null}) {
    return _then(
      _value.copyWith(
            nearbyEvents: null == nearbyEvents
                ? _value.nearbyEvents
                : nearbyEvents // ignore: cast_nullable_to_non_nullable
                      as List<EventSummaryDto>,
            recommendedEvents: null == recommendedEvents
                ? _value.recommendedEvents
                : recommendedEvents // ignore: cast_nullable_to_non_nullable
                      as List<EventSummaryDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventHomeDtoImplCopyWith<$Res>
    implements $EventHomeDtoCopyWith<$Res> {
  factory _$$EventHomeDtoImplCopyWith(
    _$EventHomeDtoImpl value,
    $Res Function(_$EventHomeDtoImpl) then,
  ) = __$$EventHomeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<EventSummaryDto> nearbyEvents,
    List<EventSummaryDto> recommendedEvents,
  });
}

/// @nodoc
class __$$EventHomeDtoImplCopyWithImpl<$Res>
    extends _$EventHomeDtoCopyWithImpl<$Res, _$EventHomeDtoImpl>
    implements _$$EventHomeDtoImplCopyWith<$Res> {
  __$$EventHomeDtoImplCopyWithImpl(
    _$EventHomeDtoImpl _value,
    $Res Function(_$EventHomeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventHomeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nearbyEvents = null, Object? recommendedEvents = null}) {
    return _then(
      _$EventHomeDtoImpl(
        nearbyEvents: null == nearbyEvents
            ? _value._nearbyEvents
            : nearbyEvents // ignore: cast_nullable_to_non_nullable
                  as List<EventSummaryDto>,
        recommendedEvents: null == recommendedEvents
            ? _value._recommendedEvents
            : recommendedEvents // ignore: cast_nullable_to_non_nullable
                  as List<EventSummaryDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventHomeDtoImpl implements _EventHomeDto {
  const _$EventHomeDtoImpl({
    final List<EventSummaryDto> nearbyEvents = const <EventSummaryDto>[],
    final List<EventSummaryDto> recommendedEvents = const <EventSummaryDto>[],
  }) : _nearbyEvents = nearbyEvents,
       _recommendedEvents = recommendedEvents;

  factory _$EventHomeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventHomeDtoImplFromJson(json);

  final List<EventSummaryDto> _nearbyEvents;
  @override
  @JsonKey()
  List<EventSummaryDto> get nearbyEvents {
    if (_nearbyEvents is EqualUnmodifiableListView) return _nearbyEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nearbyEvents);
  }

  final List<EventSummaryDto> _recommendedEvents;
  @override
  @JsonKey()
  List<EventSummaryDto> get recommendedEvents {
    if (_recommendedEvents is EqualUnmodifiableListView)
      return _recommendedEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedEvents);
  }

  @override
  String toString() {
    return 'EventHomeDto(nearbyEvents: $nearbyEvents, recommendedEvents: $recommendedEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventHomeDtoImpl &&
            const DeepCollectionEquality().equals(
              other._nearbyEvents,
              _nearbyEvents,
            ) &&
            const DeepCollectionEquality().equals(
              other._recommendedEvents,
              _recommendedEvents,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_nearbyEvents),
    const DeepCollectionEquality().hash(_recommendedEvents),
  );

  /// Create a copy of EventHomeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventHomeDtoImplCopyWith<_$EventHomeDtoImpl> get copyWith =>
      __$$EventHomeDtoImplCopyWithImpl<_$EventHomeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventHomeDtoImplToJson(this);
  }
}

abstract class _EventHomeDto implements EventHomeDto {
  const factory _EventHomeDto({
    final List<EventSummaryDto> nearbyEvents,
    final List<EventSummaryDto> recommendedEvents,
  }) = _$EventHomeDtoImpl;

  factory _EventHomeDto.fromJson(Map<String, dynamic> json) =
      _$EventHomeDtoImpl.fromJson;

  @override
  List<EventSummaryDto> get nearbyEvents;
  @override
  List<EventSummaryDto> get recommendedEvents;

  /// Create a copy of EventHomeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventHomeDtoImplCopyWith<_$EventHomeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
