import 'package:flutter/material.dart';
import 'package:trova/features/owner-profile/presentation/screens/owner_profile_screen.dart';

/// Wraps [child] so tapping it opens the project owner's public profile.
/// Mirrors [ContractorTapTarget] (core/contractor_tap_target.dart) but for
/// the reverse direction — a contractor viewing the project owner's
/// company, instead of an owner viewing a bidder.
///
/// Exactly one of [bidId] / [projectId] must be provided: [bidId] once a
/// bid exists (My Bids / Bid Detail), [projectId] before one does (browse /
/// Submit Bid) — see OwnerProfileService.fetchProfile for why these are two
/// separate lookups.
class OwnerTapTarget extends StatelessWidget {
  final String? bidId;
  final String? projectId;
  final String companyName;
  final Widget child;

  const OwnerTapTarget({super.key, this.bidId, this.projectId, required this.companyName, required this.child})
      : assert((bidId == null) != (projectId == null), 'Provide exactly one of bidId or projectId');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OwnerProfileScreen(bidId: bidId, projectId: projectId, companyName: companyName)),
      ),
      child: child,
    );
  }
}
