// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventSummaryDto _$EventSummaryDtoFromJson(Map<String, dynamic> json) {
  return _EventSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$EventSummaryDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String? get dateRange => throw _privateConstructorUsedError;
  String? get representativeDate => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  double? get distance => throw _privateConstructorUsedError;
  String? get distanceDisplay => throw _privateConstructorUsedError;
  int? get minPrice => throw _privateConstructorUsedError;
  int? get maxPrice => throw _privateConstructorUsedError;

  /// Serializes this EventSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventSummaryDtoCopyWith<EventSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventSummaryDtoCopyWith<$Res> {
  factory $EventSummaryDtoCopyWith(
    EventSummaryDto value,
    $Res Function(EventSummaryDto) then,
  ) = _$EventSummaryDtoCopyWithImpl<$Res, EventSummaryDto>;
  @useResult
  $Res call({
    int id,
    String title,
    String venueName,
    String? dateRange,
    String? representativeDate,
    String? category,
    String? thumbnailUrl,
    double? distance,
    String? distanceDisplay,
    int? minPrice,
    int? maxPrice,
  });
}

/// @nodoc
class _$EventSummaryDtoCopyWithImpl<$Res, $Val extends EventSummaryDto>
    implements $EventSummaryDtoCopyWith<$Res> {
  _$EventSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? venueName = null,
    Object? dateRange = freezed,
    Object? representativeDate = freezed,
    Object? category = freezed,
    Object? thumbnailUrl = freezed,
    Object? distance = freezed,
    Object? distanceDisplay = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            venueName: null == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String,
            dateRange: freezed == dateRange
                ? _value.dateRange
                : dateRange // ignore: cast_nullable_to_non_nullable
                      as String?,
            representativeDate: freezed == representativeDate
                ? _value.representativeDate
                : representativeDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            distance: freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double?,
            distanceDisplay: freezed == distanceDisplay
                ? _value.distanceDisplay
                : distanceDisplay // ignore: cast_nullable_to_non_nullable
                      as String?,
            minPrice: freezed == minPrice
                ? _value.minPrice
                : minPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            maxPrice: freezed == maxPrice
                ? _value.maxPrice
                : maxPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventSummaryDtoImplCopyWith<$Res>
    implements $EventSummaryDtoCopyWith<$Res> {
  factory _$$EventSummaryDtoImplCopyWith(
    _$EventSummaryDtoImpl value,
    $Res Function(_$EventSummaryDtoImpl) then,
  ) = __$$EventSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String venueName,
    String? dateRange,
    String? representativeDate,
    String? category,
    String? thumbnailUrl,
    double? distance,
    String? distanceDisplay,
    int? minPrice,
    int? maxPrice,
  });
}

/// @nodoc
class __$$EventSummaryDtoImplCopyWithImpl<$Res>
    extends _$EventSummaryDtoCopyWithImpl<$Res, _$EventSummaryDtoImpl>
    implements _$$EventSummaryDtoImplCopyWith<$Res> {
  __$$EventSummaryDtoImplCopyWithImpl(
    _$EventSummaryDtoImpl _value,
    $Res Function(_$EventSummaryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? venueName = null,
    Object? dateRange = freezed,
    Object? representativeDate = freezed,
    Object? category = freezed,
    Object? thumbnailUrl = freezed,
    Object? distance = freezed,
    Object? distanceDisplay = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
  }) {
    return _then(
      _$EventSummaryDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        venueName: null == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String,
        dateRange: freezed == dateRange
            ? _value.dateRange
            : dateRange // ignore: cast_nullable_to_non_nullable
                  as String?,
        representativeDate: freezed == representativeDate
            ? _value.representativeDate
            : representativeDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        distance: freezed == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double?,
        distanceDisplay: freezed == distanceDisplay
            ? _value.distanceDisplay
            : distanceDisplay // ignore: cast_nullable_to_non_nullable
                  as String?,
        minPrice: freezed == minPrice
            ? _value.minPrice
            : minPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        maxPrice: freezed == maxPrice
            ? _value.maxPrice
            : maxPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventSummaryDtoImpl extends _EventSummaryDto {
  const _$EventSummaryDtoImpl({
    required this.id,
    required this.title,
    required this.venueName,
    this.dateRange,
    this.representativeDate,
    this.category,
    this.thumbnailUrl,
    this.distance,
    this.distanceDisplay,
    this.minPrice,
    this.maxPrice,
  }) : super._();

  factory _$EventSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventSummaryDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String venueName;
  @override
  final String? dateRange;
  @override
  final String? representativeDate;
  @override
  final String? category;
  @override
  final String? thumbnailUrl;
  @override
  final double? distance;
  @override
  final String? distanceDisplay;
  @override
  final int? minPrice;
  @override
  final int? maxPrice;

  @override
  String toString() {
    return 'EventSummaryDto(id: $id, title: $title, venueName: $venueName, dateRange: $dateRange, representativeDate: $representativeDate, category: $category, thumbnailUrl: $thumbnailUrl, distance: $distance, distanceDisplay: $distanceDisplay, minPrice: $minPrice, maxPrice: $maxPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventSummaryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.representativeDate, representativeDate) ||
                other.representativeDate == representativeDate) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.distanceDisplay, distanceDisplay) ||
                other.distanceDisplay == distanceDisplay) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    venueName,
    dateRange,
    representativeDate,
    category,
    thumbnailUrl,
    distance,
    distanceDisplay,
    minPrice,
    maxPrice,
  );

  /// Create a copy of EventSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventSummaryDtoImplCopyWith<_$EventSummaryDtoImpl> get copyWith =>
      __$$EventSummaryDtoImplCopyWithImpl<_$EventSummaryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EventSummaryDtoImplToJson(this);
  }
}

abstract class _EventSummaryDto extends EventSummaryDto {
  const factory _EventSummaryDto({
    required final int id,
    required final String title,
    required final String venueName,
    final String? dateRange,
    final String? representativeDate,
    final String? category,
    final String? thumbnailUrl,
    final double? distance,
    final String? distanceDisplay,
    final int? minPrice,
    final int? maxPrice,
  }) = _$EventSummaryDtoImpl;
  const _EventSummaryDto._() : super._();

  factory _EventSummaryDto.fromJson(Map<String, dynamic> json) =
      _$EventSummaryDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get venueName;
  @override
  String? get dateRange;
  @override
  String? get representativeDate;
  @override
  String? get category;
  @override
  String? get thumbnailUrl;
  @override
  double? get distance;
  @override
  String? get distanceDisplay;
  @override
  int? get minPrice;
  @override
  int? get maxPrice;

  /// Create a copy of EventSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventSummaryDtoImplCopyWith<_$EventSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
