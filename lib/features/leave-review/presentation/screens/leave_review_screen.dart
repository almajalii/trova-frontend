import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/leave-review/logic/leave_review_service.dart';
import 'package:trova/features/leave-review/presentation/bloc/leave_review_bloc.dart';
import 'package:trova/features/leave-review/presentation/bloc/leave_review_event.dart';
import 'package:trova/features/leave-review/presentation/bloc/leave_review_state.dart';
import 'package:trova/features/leave-review/presentation/widget/leave_review_layout.dart';

/// Entry point for the "Leave a Review" flow.
///
/// [projectId] is the completed project being reviewed. Reached from
/// `WorkConfirmedScreen` (features/review-work) after "Confirm Complete" —
/// see the `// NOTE` left in that file pointing here.
class LeaveReviewScreen extends StatelessWidget {
  final String projectId;

  const LeaveReviewScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeaveReviewBloc(sl<LeaveReviewService>())..add(LoadReviewContext(projectId)),
      child: const _LeaveReviewView(),
    );
  }
}

class _LeaveReviewView extends StatelessWidget {
  const _LeaveReviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: BlocConsumer<LeaveReviewBloc, LeaveReviewState>(
        listener: (context, state) {
          if (state is LeaveReviewSubmitted) {
            // No dedicated confirmation frame in Figma — pop straight back
            // to wherever this was pushed from (My Projects / History),
            // same as WorkConfirmedScreen's "Done" pattern.
            Navigator.of(context).pop(true);
          } else if (state is LeaveReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is LeaveReviewLoading || state is LeaveReviewInitial || state is LeaveReviewSubmitted) {
            // LeaveReviewSubmitted is transient — the listener above pops
            // this screen the same frame, so there's nothing to render.
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LeaveReviewError && state.draft == null) {
            // Load failure with nothing to show yet.
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Go Back')),
                  ],
                ),
              ),
            );
          }

          // Either freshly loaded, or a submit-time error that carried the
          // draft along ("please rate everything" or a backend failure) —
          // both render the same editable form.
          final draft = state is LeaveReviewLoaded ? state.draft : (state as LeaveReviewError).draft!;
          final isSubmitting = state is LeaveReviewLoaded && state.isSubmitting;

          final bloc = context.read<LeaveReviewBloc>();
          return LeaveReviewLayout(
            draft: draft,
            isSubmitting: isSubmitting,
            onBack: () => Navigator.of(context).pop(),
            onRate: (category, stars) => bloc.add(RateCategory(category, stars)),
            onCommentChanged: (v) => bloc.add(ReviewCommentChanged(v)),
            onSubmit: () => bloc.add(const SubmitReview()),
          );
        },
      ),
    );
  }
}
