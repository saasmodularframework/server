import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../app_state.dart';

class AppColors {
  static bool get _dark => AppState.dark.value;

  static Color get ink => _dark ? const Color(0xFF0B0B0F) : const Color(0xFFF6F0DC);
  static Color get navy => _dark ? const Color(0xFF0A1A2F) : const Color(0xFFFFFFFF);
  static Color get light => _dark ? const Color(0xFFD4AF37) : const Color(0xFF7A5F12);
  static Color get cream => _dark ? const Color(0xFFF2E8C9) : const Color(0xFF1B1A22);

  static const emerald = Color(0xFF0B6E4F);
  static const burgundy = Color(0xFF6B1E2E);
  static const bronze = Color(0xFFB87333);
}

class ThemePreset {
  final String label;
  final Color primary;
  const ThemePreset(this.label, this.primary);
}

const themePresets = [
  ThemePreset('palette-01', Color(0xFF8A6D1F)),
  ThemePreset('palette-02', Color(0xFF0B6E4F)),
  ThemePreset('palette-03', Color(0xFF8B2E43)),
  ThemePreset('palette-04', Color(0xFF1F4E8C)),
];

RetroDesktopThemeData buildRetroTheme() {
  final preset = themePresets[AppState.preset.value.clamp(0, themePresets.length - 1)];
  return RetroDesktopThemeData.from(
    primary: preset.primary,
    brightness: AppState.dark.value ? Brightness.dark : Brightness.light,
  ).copyWith(
    appearance: AppState.chisel.value ? RetroDesktopAppearance.chisel : RetroDesktopAppearance.platinum,
  );
}

TextStyle appStyle({
  double size = 14,
  Color? color,
  FontWeight weight = FontWeight.w400,
  double spacing = 0,
  double? height,
}) =>
    TextStyle(
      color: color ?? AppColors.cream,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
      decoration: TextDecoration.none,
    );

Widget txt(
  String text, {
  double size = 14,
  Color? color,
  FontWeight weight = FontWeight.w400,
  double spacing = 0,
  double? height,
  TextAlign? align,
  int? maxLines,
}) =>
    Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: appStyle(size: size, color: color, weight: weight, spacing: spacing, height: height),
    );

