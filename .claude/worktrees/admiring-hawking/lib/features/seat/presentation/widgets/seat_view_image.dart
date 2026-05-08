import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 시야 사진을 그리는 헬퍼.
///
/// `assets/`로 시작하면 [Image.asset]으로, 그 외엔 [CachedNetworkImage]로
/// 그린다. mockup 단계에서 로컬 에셋과 원격 URL 을 섞어 쓸 수 있게 함.
class SeatViewImage extends StatelessWidget {
  const SeatViewImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholderColor = const Color(0xFF222222),
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color placeholderColor;

  bool get _isAsset => path.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: placeholderColor,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: path,
      fit: fit,
      width: width,
      height: height,
      placeholder: (_, __) => Container(
        width: width,
        height: height,
        color: placeholderColor,
      ),
      errorWidget: (_, __, ___) => Container(
        width: width,
        height: height,
        color: placeholderColor,
      ),
    );
  }
}
