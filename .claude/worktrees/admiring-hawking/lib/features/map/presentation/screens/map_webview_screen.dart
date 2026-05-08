import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/maps/map_iframe_factory.dart';
import '../../../../core/maps/map_url_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 백엔드 `/map?id={eventId}` 페이지를 보여주는 풀스크린.
///
/// - **Native (Android/iOS)**: `webview_flutter` 인앱 WebView.
/// - **Web (Chrome 등)**: `<iframe>` (HtmlElementView) + 하단에 "새 탭에서 열기" 폴백 버튼
///   (백엔드 X-Frame-Options 차단으로 빈 화면이면 사용자가 버튼으로 우회 가능).
class MapWebViewScreen extends StatefulWidget {
  const MapWebViewScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<MapWebViewScreen> createState() => _MapWebViewScreenState();
}

class _MapWebViewScreenState extends State<MapWebViewScreen> {
  WebViewController? _controller; // native only
  bool _isLoading = true;
  String? _error;
  bool _initFailed = false;
  String? _mapUrl;
  late final String _webViewId;

  /// WebView 내부에서 직접 로드해도 되는 호스트 (Native).
  static const _allowedExternalHosts = <String>{
    'oapi.map.naver.com',
    'nrbe.map.naver.com',
    'map.kakao.com',
  };

  @override
  void initState() {
    super.initState();

    try {
      _mapUrl = MapUrlBuilder.build(widget.eventId);
    } catch (_) {
      _initFailed = true;
      _isLoading = false;
      _error = '잘못된 공연 정보예요.';
      return;
    }

    if (kDebugMode) {
      developer.log('MapWebView load: $_mapUrl', name: 'MapWebView');
    }

    if (kIsWeb) {
      _webViewId = 'map-fullscreen-${widget.eventId}';
      registerMapIframe(_webViewId, _mapUrl!);
      _isLoading = false;
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _error = null;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (err) {
            if (!mounted) return;
            if (err.isForMainFrame == false) return;
            if (kDebugMode) {
              developer.log(
                'WebResourceError: code=${err.errorCode}, type=${err.errorType}, '
                'description=${err.description}',
                name: 'MapWebView',
              );
            }
            setState(() {
              _isLoading = false;
              _error = _friendlyMessage(err);
            });
          },
          onNavigationRequest: (request) async {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;

            final host = uri.host;
            final isOurMap = request.url.contains('/map?');
            if (isOurMap ||
                host.isEmpty ||
                _allowedExternalHosts.contains(host)) {
              return NavigationDecision.navigate;
            }

            try {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } catch (_) {/* 무시 */}
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_mapUrl!));
  }

  String _friendlyMessage(WebResourceError err) {
    final desc = err.description.toLowerCase();
    if (desc.contains('cleartext')) {
      return '보안 설정으로 인해 지도를 표시할 수 없어요. 운영 환경에서는 HTTPS 도메인을 사용해주세요.';
    }
    if (desc.contains('refused') ||
        desc.contains('unreachable') ||
        desc.contains('timeout') ||
        desc.contains('connection')) {
      return '서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.';
    }
    return '지도를 불러오지 못했습니다. 네트워크 상태를 확인해주세요.';
  }

  Future<void> _retry() async {
    if (kIsWeb) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await _controller?.reload();
  }

  Future<void> _openInBrowser() async {
    final url = _mapUrl;
    if (url == null) return;
    final uri = Uri.parse(url);
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지도를 열 수 없어요. 잠시 후 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '지도',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (!_initFailed)
            IconButton(
              tooltip: kIsWeb ? '새 탭에서 열기' : '새로고침',
              icon: Icon(
                kIsWeb
                    ? Icons.open_in_new_rounded
                    : Icons.refresh_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: kIsWeb ? _openInBrowser : _retry,
            ),
        ],
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_initFailed) {
      return _MapErrorView(message: _error ?? '잘못된 공연 정보예요.', onRetry: null);
    }

    if (kIsWeb) {
      // iframe + 하단 폴백 바 (지도가 안 보이면 새 탭 열기 안내).
      return Stack(
        children: [
          Positioned.fill(child: HtmlElementView(viewType: _webViewId)),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _OpenInBrowserBar(onTap: _openInBrowser),
          ),
        ],
      );
    }

    return Stack(
      children: [
        if (_error == null && _controller != null)
          WebViewWidget(controller: _controller!),
        if (_error != null)
          _MapErrorView(message: _error!, onRetry: _retry),
        if (_isLoading && _error == null)
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
      ],
    );
  }
}

/// 웹 빌드 하단 폴백 바 — iframe 이 안 보일 때를 위한 출구.
class _OpenInBrowserBar extends StatelessWidget {
  const _OpenInBrowserBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '지도가 안 보이면 새 탭에서 열어보세요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.open_in_new_rounded,
                  color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapErrorView extends StatelessWidget {
  const _MapErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined,
                size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('다시 시도'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
