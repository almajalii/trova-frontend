import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_service.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_event.dart';
import 'package:trova/features/guarantee-review/presentation/bloc/guarantee_review_state.dart';

class GuaranteeReviewBloc extends Bloc<GuaranteeReviewEvent, GuaranteeReviewState> {
  final GuaranteeReviewService guaranteeReviewService;

  GuaranteeReviewBloc({required this.guaranteeReviewService}) : super(const GuaranteeReviewInitial()) {
    on<GuaranteeReviewLoadRequested>((event, emit) async {
      emit(const GuaranteeReviewLoading());
      try {
        final guarantee = await guaranteeReviewService.fetchGuarantee(event.projectId);
        emit(GuaranteeReviewLoaded(guarantee: guarantee));
      } catch (e) {
        emit(GuaranteeReviewError(message: e.toString()));
      }
    });

    on<GuaranteeApproveRequested>((event, emit) async {
      final current = state;
      if (current is! GuaranteeReviewLoaded) return;
      emit(GuaranteeReviewSubmitting(guarantee: current.guarantee));
      try {
        final updated = await guaranteeReviewService.approveGuarantee(current.guarantee);
        emit(GuaranteeApproved(guarantee: updated));
      } catch (e) {
        emit(GuaranteeReviewError(message: e.toString()));
      }
    });

    on<GuaranteeRejectRequested>((event, emit) async {
      final current = state;
      if (current is! GuaranteeReviewLoaded) return;
      emit(GuaranteeReviewSubmitting(guarantee: current.guarantee));
      try {
        final updated = await guaranteeReviewService.rejectGuarantee(current.guarantee);
        emit(GuaranteeRejected(guarantee: updated));
      } catch (e) {
        emit(GuaranteeReviewError(message: e.toString()));
      }
    });
  }
}
