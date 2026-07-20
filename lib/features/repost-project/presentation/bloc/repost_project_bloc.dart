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
      emit(state.copyWith(draft: state.draft.copyWith(minContractorClassification: event.minContractorClassification)));
    }
  }

  void _onDescriptionChanged(RepostDescriptionChanged event, Emitter<RepostProjectState> emit) {
    final state = this.state;
    if (state is RepostProjectLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(description: event.description)));
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
      // Carry the current draft along so the form re-renders with edits
      // intact rather than reverting to the loaded snapshot.
      emit(RepostProjectError(e.message, draft: state.draft));
    }
  }
}
