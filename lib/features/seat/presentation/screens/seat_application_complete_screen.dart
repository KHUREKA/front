import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 응모 완료 화면.
///
/// 진입 애니메이션:
/// 1. 외곽 살색 링이 scale-in (`elasticOut`) 으로 통통 등장
/// 2. 안쪽 코랄 원이 살짝 늦게 따라 들어옴 (`easeOutBack`)
/// 3. 체크 마크가 stroke 로 그려짐 (drawOn)
/// 4. 타이틀 / 추첨일 / 안내 박스가 순서대로 fade-slide
///
/// 상시: 외곽 링 주위에 부드러운 펄스(반지름 + 알파)가 퍼져나간다.
class SeatApplicationCompleteScreen extends StatefulWidget {
  const SeatApplicationCompleteScreen({super.key});

  @override
  State<SeatApplicationCompleteScreen> createState() =>
      _SeatApplicationCompleteScreenState();
}

class _SeatApplicationCompleteScreenState
    extends State<SeatApplicationCompleteScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawDate = DateTime.now().add(const Duration(days: 3));
    final wd = _weekdays[drawDate.weekday - 1];
    final drawText = '${drawDate.month}월 ${drawDate.day}일 ($wd)';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // 체크 아이콘 + 펄스
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 상시 펄스 — 바깥쪽 링이 커지며 사라짐
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) {
                        final t = _pulse.value; // 0..1
                        return Container(
                          width: 120 + 60 * t,
                          height: 120 + 60 * t,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary
                                .withValues(alpha: 0.18 * (1 - t)),
                          ),
                        );
                      },
                    ),

                    // 외곽 살색 링 — scale-in
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _entrance,
                          curve: const Interval(0.0, 0.45,
                              curve: Curves.elasticOut),
                        ),
                      ),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // 안쪽 코랄 원 — 살짝 늦게
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _entrance,
                          curve: const Interval(0.10, 0.55,
                              curve: Curves.easeOutBack),
                        ),
                      ),
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // 체크 마크 — stroke draw on
                    AnimatedBuilder(
                      animation: _entrance,
                      builder: (_, __) {
                        final raw = _entrance.value;
                        // 0.45..0.85 구간을 0..1 로 매핑.
                        final t = ((raw - 0.45) / 0.40).clamp(0.0, 1.0);
                        return SizedBox(
                          width: 60,
                          height: 60,
                          child: CustomPaint(
                            painter: _CheckMarkPainter(
                              progress: Curves.easeOut.transform(t),
                              color: Colors.white,
                              strokeWidth: 7,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _FadeSlide(
                controller: _entrance,
                interval: const Interval(0.55, 0.85,
                    curve: Curves.easeOutCubic),
                child: Text(
                  '응모를 마쳤어요!',
                  style: AppTextStyles.displayLarge.copyWith(fontSize: 28),
                ),
              ),
              const SizedBox(height: 12),
              _FadeSlide(
                controller: _entrance,
                interval:
                    const Interval(0.65, 0.95, curve: Curves.easeOut),
                child: Text(
                  '$drawText에\n추첨 결과를 알려드릴게요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _FadeSlide(
                controller: _entrance,
                interval: const Interval(0.75, 1.0, curve: Curves.easeOut),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🔔',
                          style: TextStyle(fontSize: 20, height: 1)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '당첨되면 자동으로 결제되고,\n알림으로 알려드려요.',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6E5500),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => context.go(RouteNames.lottery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('응모내역 보러가기'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => context.go(RouteNames.home),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    textStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('홈으로'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 체크 마크 stroke draw-on painter.
///
/// `progress` 0..1 — `Path.computeMetrics().extractPath(0, length * progress)`
/// 로 스트로크가 한 끝점에서 다른 끝점까지 부드럽게 그려진다.
class _CheckMarkPainter extends CustomPainter {
  _CheckMarkPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 6,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final p1 = Offset(size.width * 0.20, size.height * 0.55);
    final p2 = Offset(size.width * 0.42, size.height * 0.75);
    final p3 = Offset(size.width * 0.80, size.height * 0.32);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final m = metrics.first;
    final partial = m.extractPath(0, m.length * progress);
    canvas.drawPath(partial, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckMarkPainter old) =>
      old.progress != progress || old.color != color;
}

class _FadeSlide extends StatelessWidget {
  const _FadeSlide({
    required this.controller,
    required this.interval,
    required this.child,
  });
  final AnimationController controller;
  final Interval interval;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: controller, curve: interval);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
