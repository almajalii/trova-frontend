import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/repost-project/logic/repost_project_service.dart';
import 'package:trova/features/repost-project/presentation/bloc/repost_project_event.dart';
import 'package:trova/features/repost-project/presentation/bloc/repost_project_state.dart';

class RepostProjectBloc extends Bloc<RepostProjectEvent, RepostProjectState> {
  final RepostProjectService _service;

  RepostProjectBloc(this._service) : super(const RepostProjectInitial()) {
    on<LoadRepostDraft>(_onLoadRepostDraft);
    on<RepostTitleChanged>(_onTitleChanged);
    on<RepostSectorChanged>(_onSectorChanged);
    on<RepostContractValueChanged>(_onContractValueChanged);
    on<RepostMinRequiredScoreChanged>(_onMinRequiredScoreChanged);
    on<RepostMinContractorClassificationChanged>(_onMinContractorClassificationChanged);
    on<RepostDescriptionChanged>(_onDescriptionChanged);
    on<RepostLocationChanged>(_onLocationChanged);
    on<RepostCurrencyChanged>(_onCurrencyChanged);
    on<RepostTimelineChanged>(_onTimelineChanged);
    on<RepostMilestonesChanged>(_onMilestonesChanged);
    on<RepostGuaranteeTypeChanged>(_onGuaranteeTypeChanged);
    on<RepostPaymentTermsChanged>(_onPaymentTermsChanged);
    on<RepostBidDeadlineChanged>(_onBidDeadlineChanged);
    on<SubmitRepost>(_onSubmitRepost);
  }

  Future<void> _onLoadRepostDraft(LoadRepostDraft event, Emitter<RepostProjectState> emit) async {
    emit(const RepostProjectLoading());
    try {
      final draft = await _service.fetchDraft(event.projectId);
      emit(RepostProjectLoaded(draft));
    } on ApiException catch (e) {
      emit(RepostProjectError(e.message));
    }
  }

  void _onTitleChanged(RepostTitleChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(title: event.title)));
    }
  }

  void _onSectorChanged(RepostSectorChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(sector: event.sector)));
    }
  }

  void _onContractValueChanged(RepostContractValueChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(contractValueJod: event.contractValueJod)));
    }
  }

  void _onMinRequiredScoreChanged(RepostMinRequiredScoreChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(minRequiredScore: event.minRequiredScore)));
    }
  }

  void _onMinContractorClassificationChanged(
    RepostMinContractorClassificationChanged event,
    Emitter<RepostProjectState> emit,
  ) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(
        draft: state.draft.copyWith(minContractorClassification: event.minContractorClassification),
      ));
    }
  }

  void _onDescriptionChanged(RepostDescriptionChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(description: event.description)));
    }
  }

  void _onLocationChanged(RepostLocationChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(location: event.location)));
    }
  }

  void _onCurrencyChanged(RepostCurrencyChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(currency: event.currency)));
    }
  }

  void _onTimelineChanged(RepostTimelineChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(timelineText: event.timelineText)));
    }
  }

  void _onMilestonesChanged(RepostMilestonesChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(milestones: event.milestones)));
    }
  }

  void _onGuaranteeTypeChanged(RepostGuaranteeTypeChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(guaranteeTypeRequired: event.guaranteeTypeRequired)));
    }
  }

  void _onPaymentTermsChanged(RepostPaymentTermsChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(paymentTerms: event.paymentTerms)));
    }
  }

  void _onBidDeadlineChanged(RepostBidDeadlineChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(bidSubmissionDeadline: event.bidSubmissionDeadline)));
    }
  }

  Future<void> _onSubmitRepost(SubmitRepost event, Emitter<RepostProjectState> emit) async {
    final state = this.state;
    if (state is! RepostProjectLoaded) return;
    emit(state.copyWith(isSubmitting: true));
    try {
      final newProjectId = await _service.submitRepost(state.draft);
      emit(RepostProjectSubmitted(newProjectId));
    } on ApiException catch (e) {
      emit(RepostProjectError(e.message, draft: state.draft));
    }
  }
}
