import 'text_size_option.dart';

/// 사용자 환경설정.
///
/// SharedPreferences 에 저장되어 앱 전체에서 즉시 반영.
class UserPreferences {
  const UserPreferences({
    this.textSize = TextSizeOption.medium,
    this.ttsEnabled = false,
    this.largeButtonMode = false,
    this.pushLotteryResult = true,
    this.pushPerformanceReminder = true,
    this.pushNewPerformance = true,
    this.marketingEnabled = false,
  });

  final TextSizeOption textSize;
  final bool ttsEnabled;
  final bool largeButtonMode;

  // 알림
  final bool pushLotteryResult;
  final bool pushPerformanceReminder;
  final bool pushNewPerformance;
  final bool marketingEnabled;

  UserPreferences copyWith({
    TextSizeOption? textSize,
    bool? ttsEnabled,
    bool? largeButtonMode,
    bool? pushLotteryResult,
    bool? pushPerformanceReminder,
    bool? pushNewPerformance,
    bool? marketingEnabled,
  }) {
    return UserPreferences(
      textSize: textSize ?? this.textSize,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      largeButtonMode: largeButtonMode ?? this.largeButtonMode,
      pushLotteryResult: pushLotteryResult ?? this.pushLotteryResult,
      pushPerformanceReminder:
          pushPerformanceReminder ?? this.pushPerformanceReminder,
      pushNewPerformance: pushNewPerformance ?? this.pushNewPerformance,
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
    );
  }

  static const defaults = UserPreferences();
}
