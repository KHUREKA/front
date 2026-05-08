/// 공연장의 한 구역(Section).
///
/// 구역마다 무대를 바라본 시점의 사진([stageViewImageUrl])이 있어
/// 사용자가 스와이프하면서 직접 비교할 수 있다.
class Section {
  const Section({
    required this.id,
    required this.name,
    required this.stageViewImageUrl,
    required this.distanceFromStageM,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    required this.tier,
  });

  final String id;
  final String name; // "VIP석 1구역"
  final String stageViewImageUrl;
  final double distanceFromStageM; // 무대 거리 (미터)
  final int price;
  final int totalSeats;
  final int availableSeats;
  final SeatTier tier;

  bool get isSoldOut => availableSeats <= 0;

  /// 어르신 친화 거리 표현. "약 15m" 형태.
  String get distanceLabel => '무대까지 약 ${distanceFromStageM.round()}m';
}

/// 등급. 가격대/색상 표시에 사용.
enum SeatTier {
  vip,
  r,
  s,
}

extension SeatTierX on SeatTier {
  String get displayName {
    switch (this) {
      case SeatTier.vip:
        return 'VIP석';
      case SeatTier.r:
        return 'R석';
      case SeatTier.s:
        return 'S석';
    }
  }
}
