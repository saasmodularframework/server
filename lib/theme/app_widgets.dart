import 'package:flutter/widgets.dart';

import '../app_state.dart';
import 'app_theme.dart';

class AppFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? background, border;

  const AppFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.background,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final border = this.border ?? AppColors.light;
    final background = this.background ?? AppColors.navy;
    return CustomPaint(
        foregroundPainter: _CornerPainter(border),
        child: DecoratedBox(
          decoration: BoxDecoration(color: background, border: Border.all(color: border, width: 2)),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border.all(color: border.withValues(alpha: 0.55), width: 1)),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const s = 8.0;
    void step(double x, double y, double dx, double dy) {
      canvas.drawRect(Rect.fromLTWH(dx < 0 ? x - s : x, dy < 0 ? y - s : y, s, s), paint);
    }

    step(0, 0, 1, 1);
    step(size.width, 0, -1, 1);
    step(0, size.height, 1, -1);
    step(size.width, size.height, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) => old.color != color;
}

class AppDivider extends StatelessWidget {
  final Color? color;
  const AppDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 30, width: double.infinity, child: CustomPaint(painter: _DividerPainter(color ?? AppColors.light)));
}

class _DividerPainter extends CustomPainter {
  final Color color;
  _DividerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final line = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    final fill = Paint()..color = color;
    canvas.drawLine(Offset(0, cy - 3), Offset(cx - 46, cy - 3), line);
    canvas.drawLine(Offset(0, cy + 3), Offset(cx - 46, cy + 3), line);
    canvas.drawLine(Offset(cx + 46, cy - 3), Offset(size.width, cy - 3), line);
    canvas.drawLine(Offset(cx + 46, cy + 3), Offset(size.width, cy + 3), line);

    for (var i = -3; i <= 3; i++) {
      canvas.drawLine(Offset(cx, cy + 12), Offset(cx + i * 7.0, cy - 12 + i.abs() * 2.5), line);
    }

    final d = Path()
      ..moveTo(cx, cy - 9)
      ..lineTo(cx + 9, cy)
      ..lineTo(cx, cy + 9)
      ..lineTo(cx - 9, cy)
      ..close();
    canvas.drawPath(d, fill);
    for (final dx in [-30.0, 30.0]) {
      canvas.drawRect(Rect.fromCenter(center: Offset(cx + dx, cy), width: 7, height: 7), fill);
    }
  }

  @override
  bool shouldRepaint(covariant _DividerPainter old) => old.color != color;
}

class AppHeading extends StatelessWidget {
  final String text;
  final String? subtitle;
  final double size;
  const AppHeading(this.text, {super.key, this.subtitle, this.size = 26});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          txt(text.toUpperCase(), size: size, color: AppColors.light, weight: FontWeight.w700, spacing: 4, align: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            txt(subtitle!.toUpperCase(), size: 12, spacing: 2, height: 1.5, align: TextAlign.center),
          ],
          const AppDivider(),
        ],
      );
}

class AppTag extends StatelessWidget {
  final String label;
  const AppTag(this.label, {super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: AppColors.light, width: 1), color: AppColors.navy),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: txt(label.toUpperCase(), size: 10.5, spacing: 1.6, weight: FontWeight.w700, color: AppColors.light),
        ),
      );
}

class AppTap extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const AppTap({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: child),
      );
}

class SquareSwitcher extends StatelessWidget {
  const SquareSwitcher({super.key});

  static const double _knob = 24;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: AppState.dark,
        builder: (context, dark, _) => Semantics(
          button: true,
          toggled: dark,
          label: dark ? 'Dark layout, switch to light' : 'Light layout, switch to dark',
          child: AppTap(
            onTap: () => AppState.dark.value = !dark,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                txt('LIGHT', size: 10, spacing: 2, weight: dark ? FontWeight.w400 : FontWeight.w700, color: AppColors.light),
                const SizedBox(width: 8),
                Container(
                  width: _knob * 2 + 8,
                  height: _knob + 8,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: AppColors.navy, border: Border.all(color: AppColors.light, width: 2)),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 160),
                    alignment: dark ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: _knob,
                      height: _knob,
                      decoration: BoxDecoration(color: AppColors.light, border: Border.all(color: AppColors.cream, width: 1)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                txt('DARK', size: 10, spacing: 2, weight: dark ? FontWeight.w700 : FontWeight.w400, color: AppColors.light),
              ],
            ),
          ),
        ),
      );
}

