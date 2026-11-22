import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../app_state.dart';

class AppColors {
  static bool get _dark => AppState.dark.value;


  static Color get ink => _dark ? const Color(0xFF0C0E12) : const Color(0xFFEEF0F3);
  static Color get navy => _dark ? const Color(0xFF14181F) : const Color(0xFFFFFFFF);
  static Color get light => _dark ? const Color(0xFFC4C8D0) : const Color(0xFF555B66);
  static Color get cream => _dark ? const Color(0xFFEDEFF3) : const Color(0xFF1B1C22);


  static const paper = Color(0xFFEDEFF3);

  static const emerald = Color(0xFF0B6E4F);


  static const burgundy = Color(0xFF3B4352);

  static Color get bronze => _dark ? const Color(0xFFA9BCD6) : const Color(0xFF365B8A);
}

class ThemePreset {
  final String label;
  final Color primary;
  const ThemePreset(this.label, this.primary);
}

const themePresets = [
  ThemePreset('palette-01', Color(0xFF8E939E)),
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

