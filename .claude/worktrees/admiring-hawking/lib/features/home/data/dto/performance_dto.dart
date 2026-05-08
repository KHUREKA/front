import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/performance.dart';
import '../../domain/performance_genre.dart';

part 'performance_dto.freezed.dart';
part 'performance_dto.g.dart';

/// 서버 응답 매핑용 DTO. 도메인 모델([Performance]) 과 분리해
/// API 스키마 변경의 영향을 격리한다.
@freezed
class PerformanceDto with _$PerformanceDto {
  const PerformanceDto._();

  const factory PerformanceDto({
    required String id,
    required String title,
    String? subtitle,
    required String posterImageUrl,
    required String venue,
    required String startDate, // ISO8601
    required String endDate, // ISO8601
    double? distanceKm,
    required String genre, // enum.name
    required int priceMin,
    required int priceMax,
    @Default(false) bool isLotteryOpen,
    String? lotteryDeadline, // ISO8601
  }) = _PerformanceDto;

  factory PerformanceDto.fromJson(Map<String, dynamic> json) =>
      _$PerformanceDtoFromJson(json);

  Performance toDomain() {
    return Performance(
      id: id,
      title: title,
      subtitle: subtitle,
      posterImageUrl: posterImageUrl,
      venue: venue,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      distanceKm: distanceKm,
      genre: PerformanceGenre.fromString(genre),
      priceMin: priceMin,
      priceMax: priceMax,
      isLotteryOpen: isLotteryOpen,
      lotteryDeadline:
          lotteryDeadline == null ? null : DateTime.tryParse(lotteryDeadline!),
    );
  }
}
