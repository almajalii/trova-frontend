import 'package:flutter/material.dart';
import 'package:trova/core/contractor_tap_target.dart';
import 'package:trova/features/leave-review/logic/leave_review_model.dart';

/// Pure UI for the "Leave a Review" form. No bloc references — the screen
/// wires callbacks to bloc events and passes the current [draft] down.
///
/// NOTE ON COLORS: `#c8202e` (filled star / submit button), `#d9d9de`
/// (unfilled star / field border), `#fafafa` (comment field fill),
/// `#6b7280` (subtitle), `#1a1a1a`/`#333338` (text) are literal hex from
/// Figma — same caveat as `repost_project_layout.dart`, swap for named
/// `colors.*` tokens if equivalents exist.
class LeaveReviewLayout extends StatelessWidget {
  static const _starFilled = Color(0xFFC8202E);
  static const _starEmpty = Color(0xFFD9D9DE);
  static const _fieldFill = Color(0xFFFAFAFA);
  static const _fieldBorder = Color(0xFFD9D9DE);
  static const _subtitleText = Color(0xFF6B7280);
  static const _labelText = Color(0xFF333338);
  static const _valueText = Color(0xFF1A1A1A);
  static const _hintText = Color(0xFF9999A1);

  final LeaveReviewDraft draft;
  final bool isSubmitting;
  final VoidCallback onBack;
  final void Function(ReviewCategory category, int stars) onRate;
  final ValueChanged<String> onCommentChanged;
  final VoidCallback onSubmit;

  const LeaveReviewLayout({
    super.key,
    required this.draft,
    required this.isSubmitting,
    required this.onBack,
    required this.onRate,
    required this.onCommentChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BackRow(onBack: onBack),
            const SizedBox(height: 16),
            ContractorTapTarget(
              contractor: draft.awardedBidder,
              child: Text(
                'Rate ${draft.contractorName}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _valueText),
              ),
            ),
            const SizedBox(height: 4),
            Text(draft.subtitle, style: const TextStyle(fontSize: 13, color: _subtitleText)),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final category in ReviewCategory.values) ...[
                      _RatingRow(
                        category: category,
                        stars: draft.ratings[category] ?? 0,
                        onRate: (stars) => onRate(category, stars),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Text(
                      'Additional Comments',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _labelText),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: draft.comment,
                      onChanged: onCommentChanged,
                      maxLines: 4,
                      minLines: 3,
                      style: const TextStyle(fontSize: 14, color: _valueText),
                      decoration: InputDecoration(
                        hintText: 'Share more about your experience...',
                        hintStyle: const TextStyle(fontSize: 14, color: _hintText),
                        filled: true,
                        fillColor: _fieldFill,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: _fieldBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: _fieldBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SubmitButton(enabled: draft.isComplete, isSubmitting: isSubmitting, onPressed: onSubmit),
          ],
        ),
      ),
    );
  }
}

class _BackRow extends StatelessWidget {
  final VoidCallback onBack;

  const _BackRow({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: onBack,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.arrow_back, color: LeaveReviewLayout._valueText, size: 22),
      ),
    );
  }
}

/// One category label + 5 tappable stars. Tapping star N sets the rating
/// to N (tapping the same value it's already at does not clear it — the
/// Figma frame doesn't show a "clear rating" affordance, so once rated,
/// re-tapping only changes the value).
class _RatingRow extends StatelessWidget {
  final ReviewCategory category;
  final int stars;
  final ValueChanged<int> onRate;

  const _RatingRow({required this.category, required this.stars, required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: LeaveReviewLayout._valueText),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(5, (i) {
            final filled = i < stars;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: GestureDetector(
                onTap: () => onRate(i + 1),
                child: Icon(
                  filled ? Icons.star : Icons.star_border,
                  size: 26,
                  color: filled ? LeaveReviewLayout._starFilled : LeaveReviewLayout._starEmpty,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool enabled;
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _SubmitButton({required this.enabled, required this.isSubmitting, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (enabled && !isSubmitting) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: LeaveReviewLayout._starFilled,
          disabledBackgroundColor: LeaveReviewLayout._starFilled.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text(
                'Submit Review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
      ),
    );
  }
}
