import 'package:flutter/material.dart';

/// Additive design tokens for the scoring / guarantees screens.
///
/// `core/theme.dart`'s ColorScheme only defines primary, onPrimary,
/// secondary, onSecondary, surface, surfaceBright — enough for the auth
/// flow, but the Figma "My Score", "Bidders List" and "Guarantee Verified"
/// screens need semantic status colors (success/warning/danger) and a
/// couple of light tint backgrounds that don't map cleanly onto existing
/// ColorScheme roles. Rather than overload `secondary`/`surface` with new
/// meanings and risk changing how the auth screens look, these are kept
/// as a separate, explicit set — same flat-file convention as
/// core/button.dart, core/app_text.dart etc.
///
/// If you'd rather fold these into ColorScheme.light(...) in theme.dart
/// directly (e.g. using `error`/`tertiary` roles), that works too — this
/// file just avoids touching the existing auth screens' look while adding
/// what these new screens need.
class AppColors {
  AppColors._();

  static const primaryTint = Color(0xFFF7E5E7); // light maroon — badges, chip backgrounds, score ring track

  static const success = Color(0xFF218C54);
  static const successBg = Color(0xFFE0F2E5);

  static const warning = Color(0xFFBF800D);
  static const warningBg = Color(0xFFFCF2D9);

  static const danger = Color(0xFFBF3333);
  static const dangerBg = Color(0xFFFAEBEB);

  static const neutralTagBg = Color(0xFFEDEDF0); // sector tags, tier badges
  static const neutralStatBg = Color(0xFFEBEBED); // "Total Projects" stat tile
}
