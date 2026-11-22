import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';

import '../app_state.dart';
import 'app_theme.dart';

class AppFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? background, border;

  final double radius;

  const AppFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.background,
    this.border,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final border = this.border ?? AppColors.light;
    final background = this.background ?? AppColors.navy;
    final round = radius > 0;
    final outer = round ? BorderRadius.circular(radius) : null;
    final inner = round ? BorderRadius.circular((radius - 4).clamp(0, radius).toDouble()) : null;
    final frame = DecoratedBox(
      decoration: BoxDecoration(color: background, border: Border.all(color: border, width: 2), borderRadius: outer),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: border.withValues(alpha: 0.55), width: 1), borderRadius: inner),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    if (round) return frame;
    return CustomPaint(foregroundPainter: _CornerPainter(border), child: frame);
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
    const gap = 16.0;
    for (final dy in [-3.0, 3.0]) {
      canvas.drawLine(Offset(0, cy + dy), Offset(cx - gap, cy + dy), line);
      canvas.drawLine(Offset(cx + gap, cy + dy), Offset(size.width, cy + dy), line);
    }
    canvas.drawCircle(Offset(cx, cy), 4.5, Paint()..color = color);
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

class AppRoundedTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle, leading, header;
  final List<Widget> children;
  final double radius;
  final EdgeInsets childrenPadding;

  const AppRoundedTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.header,
    this.children = const [],
    this.radius = 16,
    this.childrenPadding = const EdgeInsets.fromLTRB(12, 0, 12, 12),
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular((radius - 4).clamp(0, radius).toDouble()));
    return AppFrame(
      radius: radius,
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular((radius - 4).clamp(0, radius).toDouble()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) header!,
            Material(
              type: MaterialType.transparency,
              child: RoundedExpansionTile(
                shape: shape,
                title: title,
                subtitle: subtitle,
                leading: leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                childrenPadding: childrenPadding,
                duration: const Duration(milliseconds: 300),
                trailing: Icon(LineIcons.angleDown, size: 18, color: AppColors.light),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}