import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
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
        final colors = Theme.of(context).colorScheme;

        return Scaffold(
          backgroundColor: colors.surface,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.prefillError == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: IconButton(
                      onPressed: () {
                        if (state.currentStep == 0) {
                          Navigator.of(context).pop();
                        } else {
                          bloc.add(GuaranteeBackStep());
                        }
                      },
                      icon: Icon(Icons.arrow_back, color: colors.onSurface),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                if (!state.isPrefilling && state.prefillError == null)
                  _StepProgressBar(currentStep: state.currentStep, totalSteps: 6),
                Expanded(
                  child: state.isPrefilling
                      ? const Center(child: CircularProgressIndicator())
                      : state.prefillError != null
                          ? _PrefillErrorView(message: state.prefillError!)
                          : _buildStep(context, state, bloc),
                ),
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
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: const Color(0xFFC82333)),
          const SizedBox(height: 16),
          AppText(text: message, textSize: 14, textColor: colors.onSurface, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Button(
            text: 'Go Back',
            textColor: colors.onPrimary,
            borderRadius: 12,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            buttonWidth: 160,
            buttonHeight: 44,
            elevation: 0,
            onPressed: () => Navigator.of(context).pop(),
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
    final colors = Theme.of(context).colorScheme;
    final active = colors.primary;
    final inactive = colors.surfaceBright;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Step ${currentStep + 1} of $totalSteps',
            textSize: 13,
            fontWeight: FontWeight.w600,
            textColor: colors.secondary.withValues(alpha: 0.6),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(totalSteps, (i) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: i <= currentStep ? active : inactive,
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
