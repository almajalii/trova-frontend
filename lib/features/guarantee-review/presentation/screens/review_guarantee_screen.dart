import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_service.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_bloc.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_event.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_state.dart';
import 'package:trova/features/guarantee-review/presentation/screens/guarantee_rejected_screen.dart';
import 'package:trova/features/guarantee-review/presentation/screens/guarantee_verified_screen.dart';
import 'package:trova/features/guarantee-review/presentation/widget/review_guarantee_layout.dart';

class ReviewGuaranteeScreen extends StatelessWidget {
  final String projectId;
  const ReviewGuaranteeScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            GuaranteeReviewBloc(guaranteeReviewService: sl<GuaranteeReviewService>())
              ..add(GuaranteeReviewLoadRequested(projectId: projectId)),
        child: BlocConsumer<GuaranteeReviewBloc, GuaranteeReviewState>(
          listener: (context, state) {
            if (state is GuaranteeReviewError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is GuaranteeConfirmed) {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => GuaranteeVerifiedScreen(guarantee: state.guarantee)));
            }
            if (state is GuaranteeRejected) {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => GuaranteeRejectedScreen(guarantee: state.guarantee)));
            }
          },
          builder: (context, state) {
            if (state is GuaranteeReviewLoading || state is GuaranteeReviewInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GuaranteeReviewError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            // Loaded or Submitting both carry a guarantee to render; only the
            // button-disabled flag differs.
            final guarantee = state is GuaranteeReviewLoaded
                ? state.guarantee
                : state is GuaranteeReviewSubmitting
                ? state.guarantee
                : null;
            if (guarantee == null) return const SizedBox.shrink();

            return ReviewGuaranteeLayout(
              guarantee: guarantee,
              isSubmitting: state is GuaranteeReviewSubmitting,
              onBack: () => Navigator.of(context).maybePop(),
              onConfirm: () => context.read<GuaranteeReviewBloc>().add(const GuaranteeConfirmRequested()),
              onReject: (reason) => context.read<GuaranteeReviewBloc>().add(GuaranteeRejectRequested(reason: reason)),
            );
          },
        ),
      ),
    );
  }
}
