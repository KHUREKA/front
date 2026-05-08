import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../map/presentation/widgets/map_inline_preview.dart';
import '../../domain/transport_info.dart';

/// 교통편 섹션.
///
/// - 지도 미리보기 (placeholder Container)
/// - 주소 + 복사 버튼
/// - 지하철/버스/택시 카드
/// - "지도 앱으로 길찾기" 버튼
class TransportSection extends StatelessWidget {
  const TransportSection({
    super.key,
    required this.info,
    this.onCopyAddress,
    this.onOpenMap,
    this.onOpenMapPreview,
    this.mapEventId,
  });

  final TransportInfo info;
  final VoidCallback? onCopyAddress;
  final VoidCallback? onOpenMap;
  // 지도 미리보기 탭 핸들러 — 백엔드 /map?id=eventId WebView 진입.
  final VoidCallback? onOpenMapPreview;
  // 백엔드 이벤트 id. 있으면 placeholder 자리에 실제 지도 인라인 임베드.
  final int? mapEventId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '공연장 가는 길',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // 지도 — eventId 가 있으면 실제 지도 인라인 임베드,
        //        없으면 placeholder (탭 시 안내).
        AspectRatio(
          aspectRatio: 16 / 10,
          child: mapEventId != null && mapEventId! > 0
              ? MapInlinePreview(
                  eventId: mapEventId!,
                  onTap: onOpenMapPreview,
                )
              : Material(
                  color: const Color(0xFFE8EFF5),
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onOpenMapPreview,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _MapGridPainter()),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '지도 미리보기',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF6B7B8C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        const SizedBox(height: 16),

        // 주소
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.place_outlined,
                  size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  info.address,
                  style: AppTextStyles.bodyLarge.copyWith(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: onCopyAddress,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('복사'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 교통수단 카드들
        if (info.subway != null) ...[
          _TransportRow(
            emoji: '🚇',
            title: '지하철',
            description: info.subway!.displayLabel,
          ),
          const SizedBox(height: 10),
        ],
        if (info.bus != null) ...[
          _TransportRow(
            emoji: '🚌',
            title: '버스',
            description: info.bus!.displayLabel,
          ),
          const SizedBox(height: 10),
        ],
        if (info.taxi != null)
          _TransportRow(
            emoji: '🚕',
            title: '택시',
            description:
                '예상 요금 ${NumberFormat('#,###').format(info.taxi!.estimatedFareKrw)}원, 약 ${info.taxi!.estimatedMinutes}분',
          ),

        const SizedBox(height: 16),

        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: onOpenMap,
            icon: const Icon(Icons.directions_rounded, size: 22),
            label: const Text('지도 앱으로 길찾기'),
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
    );
  }
}

class _TransportRow extends StatelessWidget {
  const _TransportRow({
    required this.emoji,
    required this.title,
    required this.description,
  });

  final String emoji;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22, height: 1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD3DDE6)
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
