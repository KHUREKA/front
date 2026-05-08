/// 글자 크기 옵션 (4단계).
///
/// [scale] 은 `TextScaler.linear` 에 그대로 전달.
enum TextSizeOption {
  small,
  medium,
  large,
  xlarge,
}

extension TextSizeOptionX on TextSizeOption {
  String get displayName {
    switch (this) {
      case TextSizeOption.small:
        return '작게';
      case TextSizeOption.medium:
        return '보통';
      case TextSizeOption.large:
        return '크게';
      case TextSizeOption.xlarge:
        return '아주 크게';
    }
  }

  /// 미리보기 카드의 "Aa" 샘플 폰트 크기.
  double get sampleFontSize {
    switch (this) {
      case TextSizeOption.small:
        return 14;
      case TextSizeOption.medium:
        return 18;
      case TextSizeOption.large:
        return 22;
      case TextSizeOption.xlarge:
        return 26;
    }
  }

  /// 앱 전역 textScaler 배율.
  double get scale {
    switch (this) {
      case TextSizeOption.small:
        return 0.9;
      case TextSizeOption.medium:
        return 1.0;
      case TextSizeOption.large:
        return 1.2;
      case TextSizeOption.xlarge:
        return 1.4;
    }
  }

  static TextSizeOption fromIndex(int? idx) {
    if (idx == null || idx < 0 || idx >= TextSizeOption.values.length) {
      return TextSizeOption.medium;
    }
    return TextSizeOption.values[idx];
  }
}
