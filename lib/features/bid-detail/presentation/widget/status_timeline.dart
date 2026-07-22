// lib/features/biddetail/presentation/widget/status_timeline.dart

import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/features/bid-detail/logic/bide_detail_model.dart';

class StatusTimeline extends StatelessWidget {
  final List<StatusStepModel> steps;

  const StatusTimeline({super.key, required this.steps});

  static const _green = Color(0xFF1E8E3E);
  static const _red = Color(0xFFC82333);
  static const _grey = Color(0xFFD5D8DC);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.surfaceBright),
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;
          return _buildStep(step, isLast, colors);
        }),
      ),
    );
  }

  Widget _buildStep(StatusStepModel step, bool isLast, ColorScheme colors) {
    final Color dotColor;
    final Widget dotChild;
    final bool filled;

    switch (step.state) {
      case BidStepState.completed:
        dotColor = _green;
        filled = true;
        dotChild = const Icon(Icons.check, size: 12, color: Colors.white);
        break;
      case BidStepState.current:
        dotColor = _red;
        filled = true;
        dotChild = const SizedBox.shrink();
        break;
      case BidStepState.rejected:
        dotColor = _red;
        filled = true;
        dotChild = const Icon(Icons.close, size: 12, color: Colors.white);
        break;
      case BidStepState.pending:
        dotColor = _grey;
        filled = false;
        dotChild = const SizedBox.shrink();
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? dotColor : Colors.transparent,
                  border: Border.all(color: dotColor, width: filled ? 0 : 2),
                ),
                child: Center(child: dotChild),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: step.state == BidStepState.completed ? _green : _grey,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: step.label,
                    textSize: 14,
                    fontWeight: step.state == BidStepState.pending ? FontWeight.w400 : FontWeight.w600,
                    textColor: step.state == BidStepState.pending
                        ? colors.secondary.withValues(alpha: 0.5)
                        : colors.onSurface,
                    textAlign: TextAlign.start,
                  ),
                  if (step.date != null) ...[
                    const SizedBox(height: 2),
                    AppText(
                      text: step.date!,
                      textSize: 12,
                      textColor: colors.secondary.withValues(alpha: 0.6),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}