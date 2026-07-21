import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/identity-verification/logic/identity_verification_service.dart';
import 'package:trova/features/identity-verification/presentation/bloc/identity_verification_event.dart';
import 'package:trova/features/identity-verification/presentation/bloc/identity_verification_state.dart';

// Scan-ID verification no longer goes through this bloc — it's real camera +
// on-device OCR now, owned directly by ScanIdScreen (see
// presentation/screens/scan_id_screen.dart). This bloc still drives Sanad,
// which remains a deliberate mock (team decision — see
// identity_verification_service.dart).
class IdentityVerificationBloc extends Bloc<IdentityVerificationEvent, IdentityVerificationState> {
  final IdentityVerificationService identityVerificationService;

  IdentityVerificationBloc({required this.identityVerificationService}) : super(const IdentityVerificationInitial()) {
    on<SanadVerificationRequested>((event, emit) async {
      emit(const IdentityVerificationLoading());
      try {
        final info = await identityVerificationService.verifyWithSanad(fullName: event.fullName);
        emit(SanadVerificationSuccess(info: info));
      } catch (e) {
        emit(IdentityVerificationError(message: e.toString()));
      }
    });
  }
}
