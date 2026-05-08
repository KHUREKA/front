// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

/// 동일 viewId 가 두 번 등록되면 throw 가 나서 한 번만 등록되게 함.
final Set<String> _registered = <String>{};

/// 주어진 [viewId] 로 `<iframe src=url>` 을 [HtmlElementView] 가 띄울 수 있게 등록.
///
/// 백엔드에서 `X-Frame-Options` 가 풀려 있어야(`frameOptions().disable()`) 정상 표시.
/// 같은 [viewId] 가 이미 등록돼 있으면 no-op.
void registerMapIframe(String viewId, String url) {
  if (_registered.contains(viewId)) return;
  _registered.add(viewId);

  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int _) {
      final iframe = web.HTMLIFrameElement()
        ..src = url
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'fullscreen; geolocation';
      return iframe;
    },
  );
}
