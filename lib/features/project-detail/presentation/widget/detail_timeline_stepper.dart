import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/features/project-detail/logic/project_detail_model.dart';

/// Gray used for upcoming-step dots and non-done connector lines. Not in
/// AppColors since it's specific to this stepper (slightly different from
/// colors.surfaceBright).
const _neutralDot = Color(0xFFE0E0E5);

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// Formats an ISO date string (e.g. "2026-06-28") as "Jun 28, 2026", matching
/// review-work's date display convention. Falls back to the raw string if it
/// isn't a parseable ISO date, since the demo/mock data here uses
/// pre-formatted strings (e.g. "Jun 28, 2026") directly.
String _formatDate(String raw) {
  try {
    final d = DateTime.parse(raw);
    return '${_months[d.month - 1]} ${d.day}, ${d.year}';
  } on FormatException {
    return raw;
  }
}

/// The bordered "Project Timeline" card — a vertical stepper where each
/// step's dot/line color follows Figma's rule exactly:
///  - done: green dot with a check, green line to the next step
///  - active (current): primary-red dot, plain, gray line to the next step
///  - upcoming: gray dot, plain, lighter label text
///  - failed: danger-red dot with an X — always a terminal step, no line
class DetailTimelineStepper extends StatelessWidget {
  final List<DetailTimelineStep> steps;
  const DetailTimelineStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colors.surfaceBright),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            _StepRow(step: steps[i], showLine: i < steps.length - 1, colors: colors),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final DetailTimelineStep step;
  final bool showLine;
  final ColorScheme colors;

  const _StepRow({required this.step, required this.showLine, required this.colors});

  (Color dotColor, Widget? icon) _dotStyle() {
    switch (step.state) {
      case DetailStepState.done:
        return (AppColors.success, const Icon(Icons.check, size: 12, color: Colors.white));
      case DetailStepState.active:
        return (colors.primary, null);
      case DetailStepState.upcoming:
        return (_neutralDot, null);
      case DetailStepState.failed:
        return (AppColors.danger, const Icon(Icons.close, size: 12, color: Colors.white));
    }
  }

  Color get _lineColor => step.state == DetailStepState.done ? AppColors.success : _neutralDot;

  @override
  Widget build(BuildContext context) {
    final (dotColor, icon) = _dotStyle();
    final isUpcoming = step.state == DetailStepState.upcoming;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                child: icon,
              ),
              if (showLine) Container(width: 2, height: 28, color: _lineColor),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: step.label,
                    textSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: isUpcoming ? colors.onSurfaceVariant : colors.onSurface,
                    textAlign: TextAlign.start,
                  ),
                  if (step.date != null) ...[
                    const SizedBox(height: 2),
                    AppText(
                      text: _formatDate(step.date!),
                      textSize: 11,
                      textColor: colors.onSurfaceVariant,
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
