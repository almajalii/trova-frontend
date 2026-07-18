import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/bidders/logic/bidders_service.dart';
import 'package:trova/features/bidders/presentation/bloc/bidders_bloc.dart';
import 'package:trova/features/bidders/presentation/bloc/bidders_event.dart';
import 'package:trova/features/bidders/presentation/bloc/bidders_state.dart';
import 'package:trova/features/bidders/presentation/screens/compare_scores_screen.dart';
import 'package:trova/features/bidders/presentation/widget/bidders_list_layout.dart';

class BiddersListScreen extends StatefulWidget {
  final String projectId;
  final String projectTitle;
  const BiddersListScreen({super.key, required this.projectId, required this.projectTitle});

  @override
  State<BiddersListScreen> createState() => _BiddersListScreenState();
}

class _BiddersListScreenState extends State<BiddersListScreen> {
  final Set<String> _selected = {};
  static const _maxSelection = 4;
  bool _preselected = false;

  void _toggle(Bidder b) {
    if (!b.eligible) return;
    setState(() {
      if (_selected.contains(b.companyName)) {
        _selected.remove(b.companyName);
      } else if (_selected.length < _maxSelection) {
        _selected.add(b.companyName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => BiddersBloc(biddersService: sl<BiddersService>())..add(BiddersStarted(projectId: widget.projectId)),
        child: BlocConsumer<BiddersBloc, BiddersState>(
          listener: (context, state) {
            if (state is BiddersError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is BiddersLoading || state is BiddersInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BiddersError) {
              return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(state.message, textAlign: TextAlign.center)));
            }
            final bidders = (state as BiddersLoaded).bidders;

            // Pre-select the top two eligible bidders once, mirroring the
            // Figma default selection state.
            if (!_preselected) {
              _preselected = true;
              for (final b in bidders.where((b) => b.eligible).take(2)) {
                _selected.add(b.companyName);
              }
            }

            return BiddersListLayout(
              projectTitle: widget.projectTitle,
              bidders: bidders,
              selected: _selected,
              maxSelection: _maxSelection,
              onBack: () => Navigator.of(context).maybePop(),
              onToggle: _toggle,
              onCompare: _selected.length < 2
                  ? null
                  : () {
                      final chosen = bidders.where((b) => _selected.contains(b.companyName)).toList();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CompareScoresScreen(projectId: widget.projectId, projectTitle: widget.projectTitle, bidders: chosen),
                      ));
                    },
            );
          },
        ),
      ),
    );
  }
}
