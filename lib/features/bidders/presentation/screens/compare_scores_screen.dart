import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/bidders/logic/bidders_service.dart';
import 'package:trova/features/bidders/presentation/bloc/award_bloc.dart';
import 'package:trova/features/bidders/presentation/bloc/award_event.dart';
import 'package:trova/features/bidders/presentation/bloc/award_state.dart';
import 'package:trova/features/bidders/presentation/screens/bidder_profile_screen.dart';
import 'package:trova/features/bidders/presentation/widget/compare_scores_layout.dart';
import 'package:trova/features/guarantee-review/presentation/screens/project_awarded_screen.dart';

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
      body: BlocProvider(
        create: (_) => AwardBloc(biddersService: sl<BiddersService>()),
        child: BlocConsumer<AwardBloc, AwardState>(
          listener: (context, state) {
            if (state is AwardError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is AwardSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProjectAwardedScreen(
                    projectTitle: widget.projectTitle,
                    contractorName: state.awardedCompanyName,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return CompareScoresLayout(
              bidders: widget.bidders,
              selectedBidder: _selected,
              isAwarding: state is AwardLoading,
              onBack: () => Navigator.of(context).maybePop(),
              onSelectBidder: (b) => setState(() => _selected = b),
              onViewProfile: (b) =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => BidderProfileScreen(bidder: b))),
              onAward: () {
                final selected = _selected;
                if (selected == null) return;
                context.read<AwardBloc>().add(AwardRequested(projectId: widget.projectId, bidId: selected.bidId));
              },
            );
          },
        ),
      ),
    );
  }
}
