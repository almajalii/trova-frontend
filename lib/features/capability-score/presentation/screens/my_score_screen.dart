import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bank-connection/presentation/screens/connect_bank_account_screen.dart';
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
            if (state is CapabilityScoreNotFound) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: 'Connect a bank account to see your capability score',
                        textSize: 15,
                        fontWeight: FontWeight.w600,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Button(
                        text: 'Connect Bank Account',
                        textColor: Colors.white,
                        borderRadius: 10,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        elevation: 0,
                        buttonWidth: double.infinity,
                        buttonHeight: 48,
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ConnectBankAccountScreen())),
                      ),
                    ],
                  ),
                ),
              );
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
