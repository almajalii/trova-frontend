import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/home-dashboard/logic/home_dashboard_service.dart';
import 'package:trova/features/home-dashboard/presentation/bloc/home_dashboard_event.dart';
import 'package:trova/features/home-dashboard/presentation/bloc/home_dashboard_state.dart';

class HomeDashboardBloc extends Bloc<HomeDashboardEvent, HomeDashboardState> {
  final HomeDashboardService homeDashboardService;

  HomeDashboardBloc({required this.homeDashboardService}) : super(const HomeDashboardInitial()) {
    on<HomeDashboardStarted>((event, emit) async {
      emit(const HomeDashboardLoading());
      try {
        final summary = await homeDashboardService.fetchSummary();
        emit(HomeDashboardLoaded(summary: summary));
      } catch (e) {
        emit(HomeDashboardError(message: e.toString()));
      }
    });
  }
}
