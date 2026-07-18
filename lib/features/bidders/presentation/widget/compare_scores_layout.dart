import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/score_ring.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';

class CompareScoresLayout extends StatelessWidget {
  final List<Bidder> bidders; // up to 4 selected bidders
  final Bidder? selectedBidder; // tapped by the user — award target
  final VoidCallback onBack;
  final ValueChanged<Bidder> onSelectBidder;
  final VoidCallback onAward;

  const CompareScoresLayout({
    super.key,
    required this.bidders,
    required this.selectedBidder,
    required this.onBack,
    required this.onSelectBidder,
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
            IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back, color: colors.onSurface), padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
            const SizedBox(height: 8),
            AppTitle(title: 'Compare Contractors', size: 20, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.start),
            const SizedBox(height: 6),
            AppText(text: 'Tap a contractor to select them for award.', textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
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
                          selected: selectedBidder?.companyName == bidders[i].companyName,
                          onTap: () => onSelectBidder(bidders[i]),
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
                text: 'Award ${selectedBidder!.companyName}',
                textColor: Colors.white,
                borderRadius: 10,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: double.infinity,
                buttonHeight: context.buttonSizeH,
                onPressed: onAward,
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
  final VoidCallback onTap;
  const _CompareColumn({required this.bidder, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
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
            AppText(text: bidder.companyName, textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ScoreCircleBadge(score: bidder.capabilityScore, size: 56, fontSize: 20, tinted: true),
            const SizedBox(height: 10),
            _SubFactor(label: 'Liquidity', value: bidder.liquidityPct),
            _SubFactor(label: 'Revenue', value: bidder.revenuePct),
            _SubFactor(label: 'Debt', value: bidder.debtPct),
            _SubFactor(label: 'Reputation', value: bidder.reputationPct),
          ],
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          AppText(text: label, textSize: 10, textColor: colors.onSurfaceVariant),
          const SizedBox(height: 2),
          AppText(text: '$value%', textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurface),
        ],
      ),
    );
  }
}
