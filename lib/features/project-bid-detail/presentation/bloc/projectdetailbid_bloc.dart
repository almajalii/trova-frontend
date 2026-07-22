import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_service.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_event.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_state.dart';

class ProjectBidDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectBidDetailService service;
  String _bidAmount = '';

  ProjectBidDetailBloc({required this.service}) : super(const ProjectDetailInitial()) {
    on<LoadProjectDetail>(_onLoadProjectDetail);
    on<BidAmountChanged>(_onBidAmountChanged);
    on<SubmitBidPressed>(_onSubmitBidPressed);
  }

  Future<void> _onLoadProjectDetail(LoadProjectDetail event, Emitter<ProjectDetailState> emit) async {
    emit(const ProjectDetailLoading());
    try {
      final project = await service.fetchProjectDetail(event.projectId);
      emit(ProjectDetailSuccess(project: project));
    } on ApiException catch (e) {
      emit(ProjectDetailError(message: e.message));
    } catch (e) {
      emit(ProjectDetailError(message: e.toString()));
    }
  }

  void _onBidAmountChanged(BidAmountChanged event, Emitter<ProjectDetailState> emit) {
    _bidAmount = event.bidAmount;
  }

  Future<void> _onSubmitBidPressed(
      SubmitBidPressed event, Emitter<ProjectDetailState> emit) async {
    final currentState = state;
    Project? project;
    if (currentState is ProjectDetailSuccess) project = currentState.project;
    if (project == null) return;

    emit(ProjectDetailSubmitting(project: project));
    try {
      final cleanAmount = _bidAmount.replaceAll(',', '').trim();
      await service.submitBid(projectId: project.projectId, bidAmount: double.parse(cleanAmount));
      emit(const ProjectDetailSubmitted());
    } on ApiException catch (e) {
      emit(ProjectDetailError(message: e.message));
    } catch (e) {
      emit(ProjectDetailError(message: e.toString()));
    }
  }
}
