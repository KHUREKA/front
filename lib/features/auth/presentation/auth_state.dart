import 'package:flutter/foundation.dart';

/// 앱 전역 인증 상태.
///
/// 라우터의 redirect 가드가 이 상태를 구독한다.
/// 1단계 뼈대용 최소 구현. 2단계에서 Riverpod StateNotifier로 확장 예정.
class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void setAuthenticated(bool value) {
    if (_isAuthenticated == value) return;
    _isAuthenticated = value;
    notifyListeners();
  }
}
