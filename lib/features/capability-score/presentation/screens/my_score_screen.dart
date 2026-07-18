import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/capability-score/logic/capability_score_service.dart';
import 'package:trova/features/capability-score/presentation/bloc/capability_score_bloc.dart';
import 'package:trova/features/capability-score/presentation/bloc/capability_score_event.dart';
import 'package:trova/features/capability-score/presentation/bloc/capability_score_state.dart';
import 'package:trova/features/capability-score/presentation/widget/my_score_layout.dart';

class MyScoreScreen extends StatelessWidget {
  const MyScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => CapabilityScoreBloc(capabilityScoreService: sl<CapabilityScoreService>())..add(const CapabilityScoreStarted()),
        child: BlocConsumer<CapabilityScoreBloc, CapabilityScoreState>(
          listener: (context, state) {
            if (state is CapabilityScoreError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is CapabilityScoreLoading || state is CapabilityScoreInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CapabilityScoreError) {
              return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(state.message, textAlign: TextAlign.center)));
            }
            final score = (state as CapabilityScoreLoaded).score;
            return MyScoreLayout(score: score, onBack: () => Navigator.of(context).maybePop());
          },
        ),
      ),
    );
  }
}
