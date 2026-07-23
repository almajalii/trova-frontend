import 'package:flutter/material.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/bidders/presentation/screens/bidder_profile_screen.dart';

/// Wraps [child] so tapping it opens [contractor]'s public bidder profile.
/// Renders [child] untouched (no tap) when [contractor] is null — e.g. older
/// records that predate the backend sending an awarded-bidder reference.
class ContractorTapTarget extends StatelessWidget {
  final Bidder? contractor;
  final Widget child;

  const ContractorTapTarget({super.key, required this.contractor, required this.child});

  @override
  Widget build(BuildContext context) {
    final bidder = contractor;
    if (bidder == null) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BidderProfileScreen(bidder: bidder))),
      child: child,
    );
  }
}
