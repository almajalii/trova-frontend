import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';

/// Small rounded pill — classification badges, sector tags, status chips
/// (Pending / Active / Below required tier, etc.) across the new screens.
class StatusPill extends StatelessWidget {
  final String text;
  final Color? background;
  final Color? foreground;
  final FontWeight weight;
  final double fontSize;
  final EdgeInsets padding;

  const StatusPill({
    super.key,
    required this.text,
    this.background,
    this.foreground,
    this.weight = FontWeight.w600,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? AppColors.primaryTint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Inter', fontWeight: weight, fontSize: fontSize, color: foreground ?? colors.primary),
      ),
    );
  }
}
