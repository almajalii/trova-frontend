import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/score_ring.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';

class BiddersListLayout extends StatelessWidget {
  final String projectTitle;
  final List<Bidder> bidders;
  final Set<String> selected;
  final int maxSelection;
  final VoidCallback onBack;
  final ValueChanged<Bidder> onToggle;
  final VoidCallback? onCompare;

  const BiddersListLayout({
    super.key,
    required this.projectTitle,
    required this.bidders,
    required this.selected,
    required this.maxSelection,
    required this.onBack,
    required this.onToggle,
    required this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal * 0.8).copyWith(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: colors.onSurface),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 8),
            AppTitle(
              title: '$projectTitle — Bidders',
              size: 20,
              weight: FontWeight.w700,
              titleColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 6),
            AppText(
              text: '${bidders.length} contractors bid on this project. Select up to $maxSelection to compare.',
              textSize: 13,
              textColor: colors.onSurfaceVariant,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: bidders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final b = bidders[i];
                  return _BidderCard(bidder: b, selected: selected.contains(b.bidId), onTap: () => onToggle(b));
                },
              ),
            ),
            Button(
              text: 'Compare Selected (${selected.length})',
              textColor: Colors.white,
              borderRadius: 10,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              onPressed: onCompare,
            ),
          ],
        ),
      ),
    );
  }
}

class _BidderCard extends StatelessWidget {
  final Bidder bidder;
  final bool selected;
  final VoidCallback onTap;

  const _BidderCard({required this.bidder, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final highlight = selected && bidder.eligible;

    // Add comma formatting to the JOD amount
    final formattedBid = bidder.bidAmountJod.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return InkWell(
      onTap: bidder.eligible ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlight ? AppColors.primaryTint : Colors.white,
          border: Border.all(color: highlight ? colors.primary : colors.surfaceBright, width: highlight ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ScoreCircleBadge(score: bidder.capabilityScore),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: bidder.companyName,
                    textSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: colors.onSurface,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    text: 'Bid: JOD $formattedBid',
                    textSize: 12,
                    textColor: colors.onSurfaceVariant,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 6),
                  StatusPill(
                    // Changed '·' to '-' to match Figma mockup
                    text: bidder.eligible
                        ? 'Class ${bidder.classification}'
                        : 'Class ${bidder.classification} - Below required tier',
                    background: bidder.eligible ? AppColors.neutralTagBg : AppColors.dangerBg,
                    foreground: bidder.eligible ? colors.onSurfaceVariant : AppColors.danger,
                    fontSize: 10,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  ),
                ],
              ),
            ),
            // Removed eligibility check wrapper so the empty checkbox remains visible
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: highlight ? colors.primary : Colors.transparent,
                border: Border.all(color: highlight ? colors.primary : colors.surfaceBright, width: 1.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: highlight ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
