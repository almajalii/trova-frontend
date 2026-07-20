import 'package:flutter/material.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/bidders/presentation/widget/compare_scores_layout.dart';
import 'package:trova/features/guarantees/presentation/screens/award_request_guarantee_screen.dart';

class CompareScoresScreen extends StatefulWidget {
  final String projectId;
  final String projectTitle;
  final List<Bidder> bidders; // up to 3 selected bidders now

  const CompareScoresScreen({super.key, required this.projectId, required this.projectTitle, required this.bidders});

  @override
  State<CompareScoresScreen> createState() => _CompareScoresScreenState();
}

class _CompareScoresScreenState extends State<CompareScoresScreen> {
  Bidder? _selected;

  @override
  void initState() {
    super.initState();
    // Pre-select the first bidder to match Figma's active "Award [Name]" button state
    if (widget.bidders.isNotEmpty) {
      _selected = widget.bidders.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CompareScoresLayout(
        bidders: widget.bidders,
        selectedBidder: _selected,
        onBack: () => Navigator.of(context).maybePop(),
        onSelectBidder: (b) => setState(() => _selected = b),
        onAward: () {
          if (_selected == null) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AwardRequestGuaranteeScreen(
                projectId: widget.projectId,
                projectTitle: widget.projectTitle,
                awardedBidder: _selected!,
              ),
            ),
          );
        },
      ),
    );
  }
}
