// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Performance {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String get posterImageUrl => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;
  PerformanceGenre get genre => throw _privateConstructorUsedError;
  int get priceMin => throw _privateConstructorUsedError;
  int get priceMax => throw _privateConstructorUsedError;
  bool get isLotteryOpen => throw _privateConstructorUsedError;
  DateTime? get lotteryDeadline =>
      throw _privateConstructorUsedError; // 이벤트 상세(`GET /events/{id}`) 응답에서만 채워지는 부가 정보.
  // 카드용 응답(`/events/home`, `/recommend`)에서는 비어있다.
  String? get venueAddress => throw _privateConstructorUsedError;
  double? get destinationLatitude => throw _privateConstructorUsedError;
  double? get destinationLongitude => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of Performance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceCopyWith<Performance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceCopyWith<$Res> {
  factory $PerformanceCopyWith(
    Performance value,
    $Res Function(Performance) then,
  ) = _$PerformanceCopyWithImpl<$Res, Performance>;
  @useResult
  $Res call({
    String id,
    String title,
    String? subtitle,
    String posterImageUrl,
    String venue,
    DateTime startDate,
    DateTime endDate,
    double? distanceKm,
    PerformanceGenre genre,
    int priceMin,
    int priceMax,
    bool isLotteryOpen,
    DateTime? lotteryDeadline,
    String? venueAddress,
    double? destinationLatitude,
    double? destinationLongitude,
    String? description,
  });
}

/// @nodoc
class _$PerformanceCopyWithImpl<$Res, $Val extends Performance>
    implements $PerformanceCopyWith<$Res> {
  _$PerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Performance
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
    Object? venueAddress = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? description = freezed,
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
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            genre: null == genre
                ? _value.genre
                : genre // ignore: cast_nullable_to_non_nullable
                      as PerformanceGenre,
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
                      as DateTime?,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PerformanceImplCopyWith<$Res>
    implements $PerformanceCopyWith<$Res> {
  factory _$$PerformanceImplCopyWith(
    _$PerformanceImpl value,
    $Res Function(_$PerformanceImpl) then,
  ) = __$$PerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? subtitle,
    String posterImageUrl,
    String venue,
    DateTime startDate,
    DateTime endDate,
    double? distanceKm,
    PerformanceGenre genre,
    int priceMin,
    int priceMax,
    bool isLotteryOpen,
    DateTime? lotteryDeadline,
    String? venueAddress,
    double? destinationLatitude,
    double? destinationLongitude,
    String? description,
  });
}

/// @nodoc
class __$$PerformanceImplCopyWithImpl<$Res>
    extends _$PerformanceCopyWithImpl<$Res, _$PerformanceImpl>
    implements _$$PerformanceImplCopyWith<$Res> {
  __$$PerformanceImplCopyWithImpl(
    _$PerformanceImpl _value,
    $Res Function(_$PerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Performance
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
    Object? venueAddress = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$PerformanceImpl(
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
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        genre: null == genre
            ? _value.genre
            : genre // ignore: cast_nullable_to_non_nullable
                  as PerformanceGenre,
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
                  as DateTime?,
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PerformanceImpl extends _Performance {
  const _$PerformanceImpl({
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
    this.venueAddress,
    this.destinationLatitude,
    this.destinationLongitude,
    this.description,
  }) : super._();

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
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double? distanceKm;
  @override
  final PerformanceGenre genre;
  @override
  final int priceMin;
  @override
  final int priceMax;
  @override
  @JsonKey()
  final bool isLotteryOpen;
  @override
  final DateTime? lotteryDeadline;
  // 이벤트 상세(`GET /events/{id}`) 응답에서만 채워지는 부가 정보.
  // 카드용 응답(`/events/home`, `/recommend`)에서는 비어있다.
  @override
  final String? venueAddress;
  @override
  final double? destinationLatitude;
  @override
  final double? destinationLongitude;
  @override
  final String? description;

  @override
  String toString() {
    return 'Performance(id: $id, title: $title, subtitle: $subtitle, posterImageUrl: $posterImageUrl, venue: $venue, startDate: $startDate, endDate: $endDate, distanceKm: $distanceKm, genre: $genre, priceMin: $priceMin, priceMax: $priceMax, isLotteryOpen: $isLotteryOpen, lotteryDeadline: $lotteryDeadline, venueAddress: $venueAddress, destinationLatitude: $destinationLatitude, destinationLongitude: $destinationLongitude, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceImpl &&
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
                other.lotteryDeadline == lotteryDeadline) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            (identical(other.destinationLatitude, destinationLatitude) ||
                other.destinationLatitude == destinationLatitude) &&
            (identical(other.destinationLongitude, destinationLongitude) ||
                other.destinationLongitude == destinationLongitude) &&
            (identical(other.description, description) ||
                other.description == description));
  }

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
    venueAddress,
    destinationLatitude,
    destinationLongitude,
    description,
  );

  /// Create a copy of Performance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceImplCopyWith<_$PerformanceImpl> get copyWith =>
      __$$PerformanceImplCopyWithImpl<_$PerformanceImpl>(this, _$identity);
}

abstract class _Performance extends Performance {
  const factory _Performance({
    required final String id,
    required final String title,
    final String? subtitle,
    required final String posterImageUrl,
    required final String venue,
    required final DateTime startDate,
    required final DateTime endDate,
    final double? distanceKm,
    required final PerformanceGenre genre,
    required final int priceMin,
    required final int priceMax,
    final bool isLotteryOpen,
    final DateTime? lotteryDeadline,
    final String? venueAddress,
    final double? destinationLatitude,
    final double? destinationLongitude,
    final String? description,
  }) = _$PerformanceImpl;
  const _Performance._() : super._();

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
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double? get distanceKm;
  @override
  PerformanceGenre get genre;
  @override
  int get priceMin;
  @override
  int get priceMax;
  @override
  bool get isLotteryOpen;
  @override
  DateTime? get lotteryDeadline; // 이벤트 상세(`GET /events/{id}`) 응답에서만 채워지는 부가 정보.
  // 카드용 응답(`/events/home`, `/recommend`)에서는 비어있다.
  @override
  String? get venueAddress;
  @override
  double? get destinationLatitude;
  @override
  double? get destinationLongitude;
  @override
  String? get description;

  /// Create a copy of Performance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceImplCopyWith<_$PerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
