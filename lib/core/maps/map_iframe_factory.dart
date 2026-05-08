/// 플랫폼별 iframe 등록 함수 디스패치.
///
/// - 웹 빌드: `map_iframe_factory_web.dart` (실제 `<iframe>` viewFactory 등록)
/// - 그 외 빌드: `map_iframe_factory_stub.dart` (호출 시 throw — 호출자가 kIsWeb 가드)
export 'map_iframe_factory_stub.dart'
    if (dart.library.js_interop) 'map_iframe_factory_web.dart';
