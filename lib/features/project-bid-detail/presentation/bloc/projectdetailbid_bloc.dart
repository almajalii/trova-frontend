import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_service.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_event.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectDetailService service;
  String _bidAmount = '';

  ProjectDetailBloc({required this.service, required Project project})
      : super(ProjectDetailSuccess(project: project)) {
    on<BidAmountChanged>(_onBidAmountChanged);
    on<SubmitBidPressed>(_onSubmitBidPressed);
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
      await service.submitBid(projectId: project.id, bidAmount: double.parse(cleanAmount));
      emit(const ProjectDetailSubmitted());
    } catch (e) {
      emit(ProjectDetailError(message: e.toString()));
    }
  }
}