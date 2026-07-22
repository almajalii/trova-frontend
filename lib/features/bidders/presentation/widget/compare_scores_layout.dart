import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/score_ring.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';

class CompareScoresLayout extends StatelessWidget {
  final List<Bidder> bidders; // up to 3 selected bidders
  final Bidder? selectedBidder; // checked by the user — award target
  final bool isAwarding;
  final VoidCallback onBack;
  final ValueChanged<Bidder> onSelectBidder;
  final ValueChanged<Bidder> onViewProfile;
  final VoidCallback onAward;

  const CompareScoresLayout({
    super.key,
    required this.bidders,
    required this.selectedBidder,
    required this.isAwarding,
    required this.onBack,
    required this.onSelectBidder,
    required this.onViewProfile,
    required this.onAward,
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
              title: 'Compare Contractors',
              size: 20,
              weight: FontWeight.w700,
              titleColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < bidders.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(
                        child: _CompareColumn(
                          bidder: bidders[i],
                          selected: selectedBidder?.bidId == bidders[i].bidId,
                          onSelect: () => onSelectBidder(bidders[i]),
                          onTap: () => onViewProfile(bidders[i]),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (selectedBidder != null) ...[
              const SizedBox(height: 12),
              Button(
                text: isAwarding ? 'Awarding…' : 'Award ${selectedBidder!.companyName}',
                textColor: Colors.white,
                borderRadius: 10,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: double.infinity,
                buttonHeight: context.buttonSizeH,
                onPressed: isAwarding ? null : onAward,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompareColumn extends StatelessWidget {
  final Bidder bidder;
  final bool selected;
  final VoidCallback onSelect; // checkbox — award target
  final VoidCallback onTap; // rest of the card — view profile

  const _CompareColumn({required this.bidder, required this.selected, required this.onSelect, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Add comma formatting to the JOD amount
    final formattedBid = bidder.bidAmountJod.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    // Stack (not a nested GestureDetector inside the InkWell's own child
    // tree) so the checkbox unambiguously wins hit-testing over the card's
    // InkWell wherever the two would otherwise overlap — a plain nested
    // GestureDetector left both taps resolving as "select" instead of
    // splitting select vs. view-profile.
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryTint : null,
              border: Border.all(color: selected ? colors.primary : colors.surfaceBright, width: selected ? 2 : 1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const SizedBox(height: 26),
                AppText(
                  text: bidder.companyName,
                  textSize: 13,
                  fontWeight: FontWeight.w700,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ScoreCircleBadge(score: bidder.capabilityScore, size: 56, fontSize: 20, tinted: true),
                const SizedBox(height: 16),

                // New Bid Section
                AppText(text: 'Bid Submitted', textSize: 10, textColor: colors.onSurfaceVariant),
                const SizedBox(height: 4),
                AppText(text: 'JOD $formattedBid', textSize: 14, fontWeight: FontWeight.w700, textColor: colors.onSurface),
                const SizedBox(height: 12),
                Divider(color: colors.surfaceBright, height: 1),
                const SizedBox(height: 4),

                // Updated SubFactors
                _SubFactor(label: 'Current Debts', value: bidder.currentDebtsPct),
                _SubFactor(label: 'Debt Capacity', value: bidder.debtCapacityPct),
                _SubFactor(label: 'Assets Value', value: bidder.assetsValuePct),
                _SubFactor(label: 'Delinquent Debts', value: bidder.delinquentDebtsPct),
                _SubFactor(label: 'Payment History', value: bidder.paymentHistoryPct),
                _SubFactor(label: 'Current Workload', value: bidder.currentWorkloadPct),
                _SubFactor(label: 'Delivery History', value: bidder.deliveryHistoryPct),
                _SubFactor(label: 'Cashflow Trends', value: bidder.cashflowTrendsPct),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSelect,
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? colors.primary : Colors.transparent,
                border: Border.all(color: selected ? colors.primary : colors.surfaceBright, width: 1.5),
              ),
              child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubFactor extends StatelessWidget {
  final String label;
  final int value;
  const _SubFactor({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Values >= 70 are green, otherwise they use the danger color
    final isHealthy = value >= 70;
    final valueColor = isHealthy ? Colors.green.shade700 : AppColors.danger;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          AppText(text: label, textSize: 10, textColor: colors.onSurfaceVariant),
          const SizedBox(height: 4),
          AppText(text: '$value%', textSize: 13, fontWeight: FontWeight.w700, textColor: valueColor),
        ],
      ),
    );
  }
}
