import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/domain/performance_genre.dart';
import '../domain/user_preferences.dart';
import '../domain/user_profile.dart';
import 'mock_mypage_repository.dart';

/// 마이페이지 데이터 접근 인터페이스.
abstract class MyPageRepository {
  Future<UserProfile> getProfile();
  Future<UserPreferences> getPreferences();
  Future<void> updatePreferences(UserPreferences prefs);

  Future<void> updateGuardian({required String name, required String phone});
  Future<void> removeGuardian();

  Future<void> updateInterests(List<PerformanceGenre> genres);

  /// 비밀번호 변경.
  /// Mock 에서는 [oldPw] == 'wrongpw' 일 때 [MyPageException] 발생.
  Future<void> changePassword({
    required String oldPw,
    required String newPw,
  });

  Future<void> withdrawAccount({required String password});
}

/// 마이페이지 도메인 예외.
class MyPageException implements Exception {
  const MyPageException(this.message);
  final String message;
  @override
  String toString() => 'MyPageException: $message';
}

/// SharedPreferences provider — main.dart 에서 override.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be overridden in main.dart',
  );
});

/// 앱 전역 [MyPageRepository] provider — 현재는 Mock.
final mypageRepositoryProvider = Provider<MyPageRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MockMyPageRepository(prefs);
});
