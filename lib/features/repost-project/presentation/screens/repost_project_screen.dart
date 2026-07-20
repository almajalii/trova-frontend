import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/repost-project/logic/repost_project_service.dart';
import 'package:trova/features/repost-project/presentation/bloc/repost_project_bloc.dart';
import 'package:trova/features/repost-project/presentation/bloc/repost_project_event.dart';
import 'package:trova/features/repost-project/presentation/bloc/repost_project_state.dart';
import 'package:trova/features/repost-project/presentation/widget/repost_project_layout.dart';

/// Entry point for the "Edit & Re-post Project" flow.
///
/// [projectId] is the *original* project being reposted — e.g. the one
/// whose contractor backed off, or whose guarantee the owner rejected.
/// Reached from Contractor Backed Off's and Guarantee Rejected by You's
/// "Post Project Again" action button on Project Detail / My Projects.
class RepostProjectScreen extends StatelessWidget {
  final String projectId;

  const RepostProjectScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RepostProjectBloc(sl<RepostProjectService>())..add(LoadRepostDraft(projectId)),
      child: const _RepostProjectView(),
    );
  }
}

class _RepostProjectView extends StatelessWidget {
  const _RepostProjectView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: BlocConsumer<RepostProjectBloc, RepostProjectState>(
        listener: (context, state) {
          if (state is RepostProjectSubmitted) {
            // Repost succeeded — new project now exists. Pop back to
            // My Projects; that list re-fetches on return so the new
            // active project shows up.
            Navigator.of(context).pop(state.newProjectId);
          } else if (state is RepostProjectError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is RepostProjectLoading || state is RepostProjectInitial || state is RepostProjectSubmitted) {
            // RepostProjectSubmitted is transient — the listener above pops
            // this screen the same frame, so there's nothing to render.
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RepostProjectError && state.draft == null) {
            // Load failure with nothing to show — no draft to render the
            // form with.
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
          // draft along — both render the same editable form.
          final draft = state is RepostProjectLoaded ? state.draft : (state as RepostProjectError).draft!;
          final isSubmitting = state is RepostProjectLoaded && state.isSubmitting;

          final bloc = context.read<RepostProjectBloc>();
          return RepostProjectLayout(
            draft: draft,
            isSubmitting: isSubmitting,
            onBack: () => Navigator.of(context).pop(),
            onTitleChanged: (v) => bloc.add(RepostTitleChanged(v)),
            onSectorChanged: (v) => bloc.add(RepostSectorChanged(v)),
            onContractValueChanged: (v) => bloc.add(RepostContractValueChanged(v)),
            onMinRequiredScoreChanged: (v) => bloc.add(RepostMinRequiredScoreChanged(v)),
            onMinContractorClassificationChanged: (v) => bloc.add(RepostMinContractorClassificationChanged(v)),
            onDescriptionChanged: (v) => bloc.add(RepostDescriptionChanged(v)),
            onSubmit: () => bloc.add(const SubmitRepost()),
          );
        },
      ),
    );
  }
}
