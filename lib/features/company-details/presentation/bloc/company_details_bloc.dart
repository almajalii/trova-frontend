import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/company-details/logic/company_details_service.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_event.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_state.dart';

class CompanyDetailsBloc extends Bloc<CompanyDetailsEvent, CompanyDetailsState> {
  final CompanyDetailsService companyDetailsService;

  CompanyDetailsBloc({required this.companyDetailsService}) : super(const CompanyDetailsInitial()) {
    on<CompanyDetailsSubmitted>((event, emit) async {
      emit(const CompanyDetailsLoading());
      try {
        final classificationLabel = await companyDetailsService.submit(event.draft);
        emit(CompanyDetailsSuccess(classificationLabel: classificationLabel));
      } catch (e) {
        emit(CompanyDetailsError(message: e.toString()));
      }
    });
  }
}
