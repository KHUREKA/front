import 'package:shared_preferences/shared_preferences.dart';

import '../../home/domain/performance_genre.dart';
import '../domain/text_size_option.dart';
import '../domain/user_preferences.dart';
import '../domain/user_profile.dart';
import 'mypage_repository.dart';

/// Mock 구현.
///
/// - Profile: 가짜 기본 프로필 + SharedPreferences 에 보호자/관심장르 오버라이드
/// - Preferences: SharedPreferences 에 실제 저장 (앱 재실행해도 유지)
/// - 비밀번호 변경: oldPw == 'wrongpw' 면 예외
class MockMyPageRepository implements MyPageRepository {
  MockMyPageRepository(this._prefs);

  final SharedPreferences _prefs;

  // ─────────────────────────────────────
  // SharedPreferences keys
  // ─────────────────────────────────────
  static const _kTextSize = 'pref_text_size';
  static const _kTts = 'pref_tts';
  static const _kLargeButton = 'pref_large_button';
  static const _kPushLottery = 'pref_push_lottery';
  static const _kPushReminder = 'pref_push_reminder';
  static const _kPushNew = 'pref_push_new';
  static const _kMarketing = 'pref_marketing';

  static const _kGuardianName = 'profile_guardian_name';
  static const _kGuardianPhone = 'profile_guardian_phone';
  static const _kInterests = 'profile_interests'; // CSV of enum names

  // ─────────────────────────────────────
  // Profile
  // ─────────────────────────────────────
  @override
  Future<UserProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 250));

    final guardianName = _prefs.getString(_kGuardianName);
    final guardianPhone = _prefs.getString(_kGuardianPhone);
    final interestsCsv = _prefs.getString(_kInterests);
    final interests = interestsCsv == null || interestsCsv.isEmpty
        ? <PerformanceGenre>[
            PerformanceGenre.trot,
            PerformanceGenre.musical,
          ]
        : interestsCsv
            .split(',')
            .map(PerformanceGenre.fromString)
            .toList(growable: false);

    return UserProfile(
      id: 'mock-user-1',
      name: '김영희',
      email: 'younghee@example.com',
      phone: '010-1234-5678',
      joinedAt: DateTime(2024, 3, 15),
      interests: interests,
      guardianName: guardianName,
      guardianPhone: guardianPhone,
    );
  }

  @override
  Future<void> updateGuardian({
    required String name,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    await _prefs.setString(_kGuardianName, name);
    await _prefs.setString(_kGuardianPhone, phone);
  }

  @override
  Future<void> removeGuardian() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _prefs.remove(_kGuardianName);
    await _prefs.remove(_kGuardianPhone);
  }

  @override
  Future<void> updateInterests(List<PerformanceGenre> genres) async {
    await Future.delayed(const Duration(milliseconds: 350));
    if (genres.isEmpty) {
      throw const MyPageException('관심 장르를 최소 1개 이상 골라주세요.');
    }
    await _prefs.setString(
      _kInterests,
      genres.map((g) => g.name).join(','),
    );
  }

  // ─────────────────────────────────────
  // Preferences
  // ─────────────────────────────────────
  @override
  Future<UserPreferences> getPreferences() async {
    return UserPreferences(
      textSize: TextSizeOptionX.fromIndex(_prefs.getInt(_kTextSize)),
      ttsEnabled: _prefs.getBool(_kTts) ?? false,
      largeButtonMode: _prefs.getBool(_kLargeButton) ?? false,
      pushLotteryResult: _prefs.getBool(_kPushLottery) ?? true,
      pushPerformanceReminder: _prefs.getBool(_kPushReminder) ?? true,
      pushNewPerformance: _prefs.getBool(_kPushNew) ?? true,
      marketingEnabled: _prefs.getBool(_kMarketing) ?? false,
    );
  }

  @override
  Future<void> updatePreferences(UserPreferences prefs) async {
    await _prefs.setInt(_kTextSize, prefs.textSize.index);
    await _prefs.setBool(_kTts, prefs.ttsEnabled);
    await _prefs.setBool(_kLargeButton, prefs.largeButtonMode);
    await _prefs.setBool(_kPushLottery, prefs.pushLotteryResult);
    await _prefs.setBool(_kPushReminder, prefs.pushPerformanceReminder);
    await _prefs.setBool(_kPushNew, prefs.pushNewPerformance);
    await _prefs.setBool(_kMarketing, prefs.marketingEnabled);
  }

  // ─────────────────────────────────────
  // Password / Withdraw
  // ─────────────────────────────────────
  @override
  Future<void> changePassword({
    required String oldPw,
    required String newPw,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (oldPw == 'wrongpw') {
      throw const MyPageException('현재 비밀번호가 맞지 않아요.');
    }
    // Mock 에서는 실제 저장 안 함.
  }

  @override
  Future<void> withdrawAccount({required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (password == 'wrongpw') {
      throw const MyPageException('비밀번호가 맞지 않아요.');
    }
    // Mock: 모든 SharedPreferences 정리.
    await _prefs.clear();
  }
}
