import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/email-verification/logic/verify_email_service.dart';
import 'package:trova/features/email-verification/presentation/bloc/verify_email_event.dart';
import 'package:trova/features/email-verification/presentation/bloc/verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  final VerifyEmailService verifyEmailService;

  VerifyEmailBloc({required this.verifyEmailService}) : super(const VerifyEmailInitial()) {
    on<VerifyEmailCodeSubmitted>((event, emit) async {
      emit(const VerifyEmailLoading());
      try {
        await verifyEmailService.verifyCode(event.code);
        emit(const VerifyEmailSuccess());
      } catch (e) {
        emit(VerifyEmailError(message: e.toString()));
      }
    });

    on<VerifyEmailResendRequested>((event, emit) async {
      emit(const VerifyEmailLoading());
      try {
        await verifyEmailService.resendCode();
        emit(const VerifyEmailResendSuccess());
      } catch (e) {
        emit(VerifyEmailError(message: e.toString()));
      }
    });
  }
}
