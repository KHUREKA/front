/// Native(Android/iOS) 빌드용 stub.
///
/// 호출되지 않는다 — 호출자가 `kIsWeb` 가드 후에만 호출.
void registerMapIframe(String viewId, String url) {
  throw UnsupportedError('Map iframe is only available on web');
}
