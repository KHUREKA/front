import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';
import 'api_endpoints.dart';

/// 401 발생 시 호출되는 콜백.
/// 앱 초기화 단계에서 라우터로 /login 이동하도록 등록한다.
typedef UnauthorizedHandler = FutureOr<void> Function();

/// Dio 싱글턴 래퍼.
///
/// - JWT를 SecureStorage에서 읽어 Authorization 헤더에 자동 첨부
/// - 401 응답 시 토큰 삭제 + 외부 콜백 호출 (라우터에서 /login 이동)
/// - 에러를 한국어 메시지로 변환 ([friendlyMessageFromError])
class DioClient {
  DioClient({
    required SecureStorage storage,
    UnauthorizedHandler? onUnauthorized,
    String? baseUrl,
  })  : _storage = storage,
        _onUnauthorized = onUnauthorized {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(_authInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }
  }

  final SecureStorage _storage;
  UnauthorizedHandler? _onUnauthorized;
  late final Dio _dio;

  /// Dio 인스턴스 노출 (Repository에서 사용).
  Dio get dio => _dio;

  /// 앱 초기화 후 라우터가 준비되면 401 핸들러를 등록한다.
  void setUnauthorizedHandler(UnauthorizedHandler handler) {
    _onUnauthorized = handler;
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 인증이 필요 없는 요청은 'skipAuth' 플래그로 건너뛸 수 있음
        final skipAuth = options.extra['skipAuth'] == true;
        if (!skipAuth) {
          final token = await _storage.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _storage.clearTokens();
          // 라우터로 /login 이동
          await _onUnauthorized?.call();
        }
        handler.next(error);
      },
    );
  }
}

/// Dio 에러를 어르신 친화적 한국어 메시지로 변환.
///
/// UI에서 try/catch 후 이 함수를 호출해 SnackBar/Dialog에 표시.
String friendlyMessageFromError(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '네트워크가 느립니다. 잠시 후 다시 시도해주세요.';

      case DioExceptionType.badCertificate:
        return '보안 연결에 문제가 있어요. 잠시 후 다시 시도해주세요.';

      case DioExceptionType.connectionError:
        return '네트워크 연결을 확인해주세요.';

      case DioExceptionType.cancel:
        return '요청이 취소되었어요.';

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return '인터넷에 연결되어 있지 않아요. 연결을 확인해주세요.';
        }
        return '잠시 후 다시 시도해주세요.';

      case DioExceptionType.badResponse:
        final code = error.response?.statusCode ?? 0;
        // 서버가 보낸 한국어 메시지가 있으면 우선 사용
        final serverMessage = _extractServerMessage(error.response?.data);
        if (serverMessage != null && serverMessage.isNotEmpty) {
          return serverMessage;
        }
        if (code == 400) return '입력하신 내용을 다시 확인해주세요.';
        if (code == 401) return '다시 로그인해주세요.';
        if (code == 403) return '이 기능을 사용할 권한이 없어요.';
        if (code == 404) return '요청하신 내용을 찾을 수 없어요.';
        if (code == 408) return '요청 시간이 초과되었어요. 잠시 후 다시 시도해주세요.';
        if (code == 409) return '이미 처리된 요청이에요.';
        if (code == 429) return '요청이 너무 많아요. 잠시 후 다시 시도해주세요.';
        if (code >= 500) return '서버에 문제가 생겼어요. 잠시 후 다시 시도해주세요.';
        return '잠시 후 다시 시도해주세요.';
    }
  }

  if (error is SocketException) {
    return '인터넷에 연결되어 있지 않아요. 연결을 확인해주세요.';
  }

  return '문제가 생겼어요. 잠시 후 다시 시도해주세요.';
}

String? _extractServerMessage(Object? data) {
  if (data is Map) {
    final value = data['message'] ?? data['error'] ?? data['detail'];
    if (value is String) return value;
  }
  return null;
}

/// 앱 전역 [DioClient] 싱글턴 provider.
///
/// 401 핸들러는 라우터 초기화 후에 [DioClient.setUnauthorizedHandler] 로 등록한다.
final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioClient(storage: storage);
});
