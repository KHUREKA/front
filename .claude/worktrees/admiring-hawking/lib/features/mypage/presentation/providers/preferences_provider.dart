import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/mypage_repository.dart';
import '../../domain/text_size_option.dart';
import '../../domain/user_preferences.dart';

/// 사용자 환경설정 StateNotifier.
///
/// SharedPreferences 에서 동기적으로 로드한 뒤, 변경 시 즉시 영속화.
/// 토글 한 번에 setState + saveToDisk → 부드러운 UX.
class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  // SharedPreferences keys (MockMyPageRepository 와 일치).
  static const _kTextSize = 'pref_text_size';
  static const _kTts = 'pref_tts';
  static const _kLargeButton = 'pref_large_button';
  static const _kPushLottery = 'pref_push_lottery';
  static const _kPushReminder = 'pref_push_reminder';
  static const _kPushNew = 'pref_push_new';
  static const _kMarketing = 'pref_marketing';

  static UserPreferences _load(SharedPreferences p) {
    return UserPreferences(
      textSize: TextSizeOptionX.fromIndex(p.getInt(_kTextSize)),
      ttsEnabled: p.getBool(_kTts) ?? false,
      largeButtonMode: p.getBool(_kLargeButton) ?? false,
      pushLotteryResult: p.getBool(_kPushLottery) ?? true,
      pushPerformanceReminder: p.getBool(_kPushReminder) ?? true,
      pushNewPerformance: p.getBool(_kPushNew) ?? true,
      marketingEnabled: p.getBool(_kMarketing) ?? false,
    );
  }

  Future<void> setTextSize(TextSizeOption opt) async {
    state = state.copyWith(textSize: opt);
    await _prefs.setInt(_kTextSize, opt.index);
  }

  Future<void> setTts(bool v) async {
    state = state.copyWith(ttsEnabled: v);
    await _prefs.setBool(_kTts, v);
  }

  Future<void> setLargeButton(bool v) async {
    state = state.copyWith(largeButtonMode: v);
    await _prefs.setBool(_kLargeButton, v);
  }

  Future<void> setPushLottery(bool v) async {
    state = state.copyWith(pushLotteryResult: v);
    await _prefs.setBool(_kPushLottery, v);
  }

  Future<void> setPushReminder(bool v) async {
    state = state.copyWith(pushPerformanceReminder: v);
    await _prefs.setBool(_kPushReminder, v);
  }

  Future<void> setPushNew(bool v) async {
    state = state.copyWith(pushNewPerformance: v);
    await _prefs.setBool(_kPushNew, v);
  }

  Future<void> setMarketing(bool v) async {
    state = state.copyWith(marketingEnabled: v);
    await _prefs.setBool(_kMarketing, v);
  }
}

/// 앱 전역 사용자 환경설정.
final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return UserPreferencesNotifier(prefs);
  },
);
