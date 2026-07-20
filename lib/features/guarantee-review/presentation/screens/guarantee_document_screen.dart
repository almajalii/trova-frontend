import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_service.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_bloc.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_event.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_state.dart';
import 'package:trova/features/guarantee-review/presentation/widget/guarantee_document_layout.dart';

class GuaranteeDocumentScreen extends StatelessWidget {
  final String projectId;
  const GuaranteeDocumentScreen({super.key, required this.projectId});

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
            if (state is! GuaranteeReviewLoaded) return const SizedBox.shrink();

            return GuaranteeDocumentLayout(
              guarantee: state.guarantee,
              onBack: () => Navigator.of(context).maybePop(),
              onReverify: () {
                // TODO: hook up to a real re-verification call once the bank
                // integration exists.
              },
              onDownloadPdf: () {
                // TODO: hook up to real PDF generation/download once available.
              },
            );
          },
        ),
      ),
    );
  }
}
