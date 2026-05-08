import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/maps/map_iframe_factory.dart';
import '../../../../core/maps/map_url_builder.dart';
import '../../../../core/theme/app_colors.dart';

/// 백엔드 `/map?id={eventId}` 페이지의 인라인 미리보기.
///
/// - **Native (Android/iOS)**: `webview_flutter` 로 실제 지도 임베드.
/// - **Web**: `<iframe>` 을 [HtmlElementView] 로 띄움.
///   ⚠️ 백엔드 Spring Security 가 `X-Frame-Options.disable()` 로 풀려 있어야 보임.
///
/// 인라인은 정적 미리보기로 의도 — 위에 투명 InkWell 깔아 직접 패닝/줌 막고,
/// 탭하면 [onTap] 으로 풀스크린 진입.
class MapInlinePreview extends StatefulWidget {
  const MapInlinePreview({
    super.key,
    required this.eventId,
    this.onTap,
    this.borderRadius = 16,
  });

  final int eventId;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  State<MapInlinePreview> createState() => _MapInlinePreviewState();
}

class _MapInlinePreviewState extends State<MapInlinePreview> {
  WebViewController? _controller; // native only
  late final String _url;
  late final String _viewId;
  bool _initFailed = false;

  @override
  void initState() {
    super.initState();
    try {
      _url = MapUrlBuilder.build(widget.eventId);
    } catch (_) {
      _initFailed = true;
      return;
    }
    _viewId = 'map-iframe-${widget.eventId}';

    if (kIsWeb) {
      registerMapIframe(_viewId, _url);
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..loadRequest(Uri.parse(_url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initFailed) {
      return _PlaceholderBox(
        borderRadius: widget.borderRadius,
        label: '지도 정보를 불러올 수 없어요',
        onTap: widget.onTap,
      );
    }

    final Widget mapWidget = kIsWeb
        ? HtmlElementView(viewType: _viewId)
        : WebViewWidget(controller: _controller!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        children: [
          Positioned.fill(child: mapWidget),
          // 투명 오버레이 — 인라인은 정적, 탭하면 풀스크린.
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          if (widget.onTap != null)
            const Positioned(
              top: 8,
              right: 8,
              child: IgnorePointer(child: _ZoomChip()),
            ),
        ],
      ),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  const _PlaceholderBox({
    required this.borderRadius,
    required this.label,
    this.onTap,
  });

  final double borderRadius;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8EFF5),
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomChip extends StatelessWidget {
  const _ZoomChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fullscreen_rounded, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            '지도 보기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
