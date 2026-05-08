/// 응모 결과를 표현하는 모델.
///
/// 추첨 응모를 백엔드에 제출했을 때 돌려받는 정보 (지금은 Mock 으로 생성).
class LotteryApplication {
  const LotteryApplication({
    required this.id,
    required this.performanceId,
    required this.companionCount,
    required this.scheduledDrawAt,
    required this.estimatedTotalPrice,
  });

  final String id;
  final String performanceId;
  final int companionCount;
  final DateTime scheduledDrawAt; // 추첨 예정 시각
  final int estimatedTotalPrice; // 당첨 시 결제될 예상 금액
}
