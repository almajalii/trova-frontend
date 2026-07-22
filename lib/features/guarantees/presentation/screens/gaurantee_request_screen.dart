import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_bloc.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_event.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_state.dart';
import 'package:trova/features/guarantees/presentation/widget/gaurantee1.dart';
import 'package:trova/features/guarantees/presentation/widget/gaurantee2.dart';
import 'package:trova/features/guarantees/presentation/widget/gaurantee3.dart';
import 'package:trova/features/guarantees/presentation/widget/gaurantee4.dart';
import 'package:trova/features/guarantees/presentation/widget/gaurantee5.dart';
import 'package:trova/features/guarantees/presentation/widget/gaurantee6.dart';
import 'package:trova/features/guarantees/presentation/widget/submit.dart';


class GuaranteeRequestScreen extends StatelessWidget {
  const GuaranteeRequestScreen({super.key});

  static const _stepTitles = [
    'Applicant Info',
    'Project Details',
    'Guarantee Details',
    'Beneficiary Info',
    'Documents',
    'Declarations',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuaranteeRequestBloc, GuaranteeRequestState>(
    listener: (context, state) {
  if (state.status == GuaranteeStatus.success) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GuaranteeSubmittedScreen()),
    );
  }
  if (state.status == GuaranteeStatus.error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
    );
  }
},
      builder: (context, state) {
        final bloc = context.read<GuaranteeRequestBloc>();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (state.currentStep == 0) {
                  Navigator.of(context).pop();
                } else {
                  bloc.add(GuaranteeBackStep());
                }
              },
            ),
            title: Text(state.isPrefilling || state.prefillError != null
                ? 'Guarantee Application'
                : 'Guarantee Step ${state.currentStep + 1} - ${_stepTitles[state.currentStep]}'),
          ),
          body: SafeArea(
            child: state.isPrefilling
                ? const Center(child: CircularProgressIndicator())
                : state.prefillError != null
                    ? _PrefillErrorView(message: state.prefillError!)
                    : Column(
                        children: [
                          _StepProgressBar(currentStep: state.currentStep, totalSteps: 6),
                          Expanded(child: _buildStep(context, state, bloc)),
                        ],
                      ),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, GuaranteeRequestState state, GuaranteeRequestBloc bloc) {
    void onChanged(model) => bloc.add(GuaranteeStepDataChanged(model));
    void onContinue() {
      if (state.currentStep == 5) {
        bloc.add(GuaranteeSubmitRequested());
      } else {
        bloc.add(GuaranteeNextStep());
      }
    }

    switch (state.currentStep) {
      case 0:
        return GuaranteeStep1ApplicantLayout(model: state.model, onChanged: onChanged, onContinue: onContinue);
      case 1:
        return GuaranteeStep2ProjectLayout(model: state.model, onChanged: onChanged, onContinue: onContinue);
      case 2:
        return GuaranteeStep3DetailsLayout(model: state.model, onChanged: onChanged, onContinue: onContinue);
      case 3:
        return GuaranteeStep4BeneficiaryLayout(model: state.model, onChanged: onChanged, onContinue: onContinue);
      case 4:
        return GuaranteeStep5DocumentsLayout(model: state.model, onChanged: onChanged, onContinue: onContinue);
      case 5:
        return GuaranteeStep6DeclarationsLayout(
          model: state.model,
          onChanged: onChanged,
          onSubmit: onContinue,
          isSubmitting: state.status == GuaranteeStatus.loading,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _PrefillErrorView extends StatelessWidget {
  final String message;
  const _PrefillErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

class _StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const _StepProgressBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final inactive = Theme.of(context).colorScheme.surfaceBright;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${currentStep + 1} of $totalSteps',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(totalSteps, (i) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: i <= currentStep ? color : inactive,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}