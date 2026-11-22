import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';

class PageLoader extends StatelessWidget {
  final double size;
  final bool showLabel;
  const PageLoader({super.key, this.size = 72, this.showLabel = true});

  Widget _spiral() => const _CoreSpiral();

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Loading',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: FittedBox(child: _spiral()),
            ),
            if (showLabel) ...[
              const SizedBox(height: 14),
              txt('LOADING', size: 11, spacing: 5, color: AppColors.light),
            ],
          ],
        ),
      );
}

class _CoreSpiral extends StatelessWidget {
  const _CoreSpiral();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 72,
        height: 72,
        child: CustomPaint(
          painter: _SpiralPainter(AppColors.light),
        ),
      );
}

class _SpiralPainter extends CustomPainter {
  final Color color;
  const _SpiralPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.45;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const turns = 2.5;
    const segments = 90;
    for (var i = 0; i <= segments; i++) {
      final t = i / segments;
      final angle = t * turns * 2 * math.pi;
      final radius = t * maxRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _SpiralPainter oldDelegate) =>
      oldDelegate.color != color;
}


