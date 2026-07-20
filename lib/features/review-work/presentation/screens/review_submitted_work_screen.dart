import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/review-work/logic/review_work_service.dart';
import 'package:trova/features/review-work/presentation/bloc/review_work_bloc.dart';
import 'package:trova/features/review-work/presentation/bloc/review_work_event.dart';
import 'package:trova/features/review-work/presentation/bloc/review_work_state.dart';
import 'package:trova/features/review-work/presentation/screens/issue_flagged_screen.dart';
import 'package:trova/features/review-work/presentation/screens/work_confirmed_screen.dart';
import 'package:trova/features/review-work/presentation/widget/review_submitted_work_layout.dart';

class ReviewSubmittedWorkScreen extends StatelessWidget {
  final String projectId;
  const ReviewSubmittedWorkScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            ReviewWorkBloc(reviewWorkService: sl<ReviewWorkService>())
              ..add(ReviewWorkLoadRequested(projectId: projectId)),
        child: BlocConsumer<ReviewWorkBloc, ReviewWorkState>(
          listener: (context, state) {
            if (state is ReviewWorkError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is WorkConfirmedComplete) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => WorkConfirmedScreen(projectTitle: state.projectTitle)),
              );
            }
            if (state is WorkIssueFlagged) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const IssueFlaggedScreen()));
            }
          },
          builder: (context, state) {
            if (state is ReviewWorkLoading || state is ReviewWorkInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReviewWorkError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            final work = state is ReviewWorkLoaded
                ? state.work
                : state is ReviewWorkSubmitting
                ? state.work
                : null;
            if (work == null) return const SizedBox.shrink();

            return ReviewSubmittedWorkLayout(
              work: work,
              isSubmitting: state is ReviewWorkSubmitting,
              onBack: () => Navigator.of(context).maybePop(),
              onFlagIssue: () => context.read<ReviewWorkBloc>().add(const FlagIssueRequested()),
              onConfirmComplete: () => context.read<ReviewWorkBloc>().add(const ConfirmCompleteRequested()),
            );
          },
        ),
      ),
    );
  }
}
