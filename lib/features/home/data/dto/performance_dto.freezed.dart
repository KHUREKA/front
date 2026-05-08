// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PerformanceDto _$PerformanceDtoFromJson(Map<String, dynamic> json) {
  return _PerformanceDto.fromJson(json);
}

/// @nodoc
mixin _$PerformanceDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String get posterImageUrl => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError; // ISO8601
  String get endDate => throw _privateConstructorUsedError; // ISO8601
  double? get distanceKm => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError; // enum.name
  int get priceMin => throw _privateConstructorUsedError;
  int get priceMax => throw _privateConstructorUsedError;
  bool get isLotteryOpen => throw _privateConstructorUsedError;
  String? get lotteryDeadline => throw _privateConstructorUsedError;

  /// Serializes this PerformanceDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerformanceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceDtoCopyWith<PerformanceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceDtoCopyWith<$Res> {
  factory $PerformanceDtoCopyWith(
    PerformanceDto value,
    $Res Function(PerformanceDto) then,
  ) = _$PerformanceDtoCopyWithImpl<$Res, PerformanceDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String? subtitle,
    String posterImageUrl,
    String venue,
    String startDate,
    String endDate,
    double? distanceKm,
    String genre,
    int priceMin,
    int priceMax,
    bool isLotteryOpen,
    String? lotteryDeadline,
  });
}

/// @nodoc
class _$PerformanceDtoCopyWithImpl<$Res, $Val extends PerformanceDto>
    implements $PerformanceDtoCopyWith<$Res> {
  _$PerformanceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerformanceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? posterImageUrl = null,
    Object? venue = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? distanceKm = freezed,
    Object? genre = null,
    Object? priceMin = null,
    Object? priceMax = null,
    Object? isLotteryOpen = null,
    Object? lotteryDeadline = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            posterImageUrl: null == posterImageUrl
                ? _value.posterImageUrl
                : posterImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            venue: null == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            genre: null == genre
                ? _value.genre
                : genre // ignore: cast_nullable_to_non_nullable
                      as String,
            priceMin: null == priceMin
                ? _value.priceMin
                : priceMin // ignore: cast_nullable_to_non_nullable
                      as int,
            priceMax: null == priceMax
                ? _value.priceMax
                : priceMax // ignore: cast_nullable_to_non_nullable
                      as int,
            isLotteryOpen: null == isLotteryOpen
                ? _value.isLotteryOpen
                : isLotteryOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            lotteryDeadline: freezed == lotteryDeadline
                ? _value.lotteryDeadline
                : lotteryDeadline // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PerformanceDtoImplCopyWith<$Res>
    implements $PerformanceDtoCopyWith<$Res> {
  factory _$$PerformanceDtoImplCopyWith(
    _$PerformanceDtoImpl value,
    $Res Function(_$PerformanceDtoImpl) then,
  ) = __$$PerformanceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? subtitle,
    String posterImageUrl,
    String venue,
    String startDate,
    String endDate,
    double? distanceKm,
    String genre,
    int priceMin,
    int priceMax,
    bool isLotteryOpen,
    String? lotteryDeadline,
  });
}

/// @nodoc
class __$$PerformanceDtoImplCopyWithImpl<$Res>
    extends _$PerformanceDtoCopyWithImpl<$Res, _$PerformanceDtoImpl>
    implements _$$PerformanceDtoImplCopyWith<$Res> {
  __$$PerformanceDtoImplCopyWithImpl(
    _$PerformanceDtoImpl _value,
    $Res Function(_$PerformanceDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PerformanceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? posterImageUrl = null,
    Object? venue = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? distanceKm = freezed,
    Object? genre = null,
    Object? priceMin = null,
    Object? priceMax = null,
    Object? isLotteryOpen = null,
    Object? lotteryDeadline = freezed,
  }) {
    return _then(
      _$PerformanceDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        posterImageUrl: null == posterImageUrl
            ? _value.posterImageUrl
            : posterImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        venue: null == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        genre: null == genre
            ? _value.genre
            : genre // ignore: cast_nullable_to_non_nullable
                  as String,
        priceMin: null == priceMin
            ? _value.priceMin
            : priceMin // ignore: cast_nullable_to_non_nullable
                  as int,
        priceMax: null == priceMax
            ? _value.priceMax
            : priceMax // ignore: cast_nullable_to_non_nullable
                  as int,
        isLotteryOpen: null == isLotteryOpen
            ? _value.isLotteryOpen
            : isLotteryOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        lotteryDeadline: freezed == lotteryDeadline
            ? _value.lotteryDeadline
            : lotteryDeadline // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceDtoImpl extends _PerformanceDto {
  const _$PerformanceDtoImpl({
    required this.id,
    required this.title,
    this.subtitle,
    required this.posterImageUrl,
    required this.venue,
    required this.startDate,
    required this.endDate,
    this.distanceKm,
    required this.genre,
    required this.priceMin,
    required this.priceMax,
    this.isLotteryOpen = false,
    this.lotteryDeadline,
  }) : super._();

  factory _$PerformanceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  final String posterImageUrl;
  @override
  final String venue;
  @override
  final String startDate;
  // ISO8601
  @override
  final String endDate;
  // ISO8601
  @override
  final double? distanceKm;
  @override
  final String genre;
  // enum.name
  @override
  final int priceMin;
  @override
  final int priceMax;
  @override
  @JsonKey()
  final bool isLotteryOpen;
  @override
  final String? lotteryDeadline;

  @override
  String toString() {
    return 'PerformanceDto(id: $id, title: $title, subtitle: $subtitle, posterImageUrl: $posterImageUrl, venue: $venue, startDate: $startDate, endDate: $endDate, distanceKm: $distanceKm, genre: $genre, priceMin: $priceMin, priceMax: $priceMax, isLotteryOpen: $isLotteryOpen, lotteryDeadline: $lotteryDeadline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.posterImageUrl, posterImageUrl) ||
                other.posterImageUrl == posterImageUrl) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.isLotteryOpen, isLotteryOpen) ||
                other.isLotteryOpen == isLotteryOpen) &&
            (identical(other.lotteryDeadline, lotteryDeadline) ||
                other.lotteryDeadline == lotteryDeadline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    subtitle,
    posterImageUrl,
    venue,
    startDate,
    endDate,
    distanceKm,
    genre,
    priceMin,
    priceMax,
    isLotteryOpen,
    lotteryDeadline,
  );

  /// Create a copy of PerformanceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceDtoImplCopyWith<_$PerformanceDtoImpl> get copyWith =>
      __$$PerformanceDtoImplCopyWithImpl<_$PerformanceDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceDtoImplToJson(this);
  }
}

abstract class _PerformanceDto extends PerformanceDto {
  const factory _PerformanceDto({
    required final String id,
    required final String title,
    final String? subtitle,
    required final String posterImageUrl,
    required final String venue,
    required final String startDate,
    required final String endDate,
    final double? distanceKm,
    required final String genre,
    required final int priceMin,
    required final int priceMax,
    final bool isLotteryOpen,
    final String? lotteryDeadline,
  }) = _$PerformanceDtoImpl;
  const _PerformanceDto._() : super._();

  factory _PerformanceDto.fromJson(Map<String, dynamic> json) =
      _$PerformanceDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get subtitle;
  @override
  String get posterImageUrl;
  @override
  String get venue;
  @override
  String get startDate; // ISO8601
  @override
  String get endDate; // ISO8601
  @override
  double? get distanceKm;
  @override
  String get genre; // enum.name
  @override
  int get priceMin;
  @override
  int get priceMax;
  @override
  bool get isLotteryOpen;
  @override
  String? get lotteryDeadline;

  /// Create a copy of PerformanceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceDtoImplCopyWith<_$PerformanceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
