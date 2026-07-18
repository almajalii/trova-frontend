import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';

/// Green checkmark badge used on confirmation screens (Bank Connected,
/// Project Awarded, Guarantee Verified).
class SuccessBadge extends StatelessWidget {
  final double size;
  final double iconSize;
  const SuccessBadge({super.key, this.size = 64, this.iconSize = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
      child: Icon(Icons.check, color: AppColors.success, size: iconSize),
    );
  }
}

/// Bottom navigation bar shared by Home Dashboard / My Projects /
/// My Guarantees / Company Profile once those screens exist.
class TrovaBottomNav extends StatelessWidget {
  final int activeIndex;
  const TrovaBottomNav({super.key, required this.activeIndex});

  static const _tabs = [
    (Icons.home_rounded, 'Home'),
    (Icons.assignment_outlined, 'Projects'),
    (Icons.verified_outlined, 'Guarantees'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: colors.surfaceBright))),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_tabs.length, (i) {
            final active = i == activeIndex;
            final color = active ? colors.primary : colors.onSurfaceVariant;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_tabs[i].$1, size: 22, color: color),
                const SizedBox(height: 4),
                Text(
                  _tabs[i].$2,
                  style: TextStyle(fontFamily: 'Inter', fontWeight: active ? FontWeight.w600 : FontWeight.w400, fontSize: 11, color: color),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
