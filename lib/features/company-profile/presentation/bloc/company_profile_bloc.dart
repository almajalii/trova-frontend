import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/company-profile/logic/company_profile_service.dart';
import 'package:trova/features/company-profile/presentation/bloc/company_profile_event.dart';
import 'package:trova/features/company-profile/presentation/bloc/company_profile_state.dart';

class CompanyProfileBloc extends Bloc<CompanyProfileEvent, CompanyProfileState> {
  final CompanyProfileService companyProfileService;

  CompanyProfileBloc({required this.companyProfileService}) : super(const CompanyProfileInitial()) {
    on<CompanyProfileRequested>((event, emit) async {
      emit(const CompanyProfileLoading());
      try {
        final profile = await companyProfileService.fetchProfile();
        emit(CompanyProfileLoaded(profile: profile));
      } on ApiException catch (e) {
        if (e.isNotFound) {
          emit(const CompanyProfileNotFound());
        } else {
          emit(CompanyProfileError(message: e.message));
        }
      } catch (e) {
        emit(CompanyProfileError(message: e.toString()));
      }
    });
  }
}
