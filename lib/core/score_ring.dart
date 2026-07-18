import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';

/// Donut ring used for capability-score displays — Home Dashboard's mini
/// badge and My Score's large hero ring both use this, just at different
/// sizes. Track = light maroon, progress = maroon.
class ScoreRing extends StatelessWidget {
  final int score; // 0-100
  final double size;
  final double strokeWidth;
  final double fontSize;

  const ScoreRing({
    super.key,
    required this.score,
    this.size = 64,
    this.strokeWidth = 7,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(value: 1, strokeWidth: 7, color: AppColors.primaryTint),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: (score.clamp(0, 100)) / 100,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              color: colors.primary,
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '$score',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: fontSize, color: colors.primary),
          ),
        ],
      ),
    );
  }
}

/// Filled circular score badge used on Bidders List (solid maroon) and
/// Compare Scores (tinted light-maroon) screens.
class ScoreCircleBadge extends StatelessWidget {
  final int score;
  final double size;
  final double fontSize;
  final bool tinted;

  const ScoreCircleBadge({
    super.key,
    required this.score,
    this.size = 44,
    this.fontSize = 14,
    this.tinted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: tinted ? AppColors.primaryTint : colors.primary, shape: BoxShape.circle),
      child: Text(
        '$score',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          color: tinted ? colors.primary : Colors.white,
        ),
      ),
    );
  }
}
