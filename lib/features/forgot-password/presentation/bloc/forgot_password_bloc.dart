import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/forgot-password/logic/forgot_password_service.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_event.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordService forgotPasswordService;

  ForgotPasswordBloc({required this.forgotPasswordService}) : super(const ForgotPasswordInitial()) {
    on<ForgotPasswordEmailSubmitted>((event, emit) async {
      emit(const ForgotPasswordLoading());
      try {
        await forgotPasswordService.requestReset(event.email);
        emit(const ForgotPasswordEmailSent());
      } catch (e) {
        emit(ForgotPasswordError(message: e.toString()));
      }
    });

    on<ForgotPasswordResendRequested>((event, emit) async {
      emit(const ForgotPasswordLoading());
      try {
        await forgotPasswordService.requestReset(event.email);
        emit(const ForgotPasswordResendSuccess());
      } catch (e) {
        emit(ForgotPasswordError(message: e.toString()));
      }
    });

    on<ForgotPasswordResetSubmitted>((event, emit) async {
      emit(const ForgotPasswordLoading());
      try {
        await forgotPasswordService.resetPassword(
          token: event.token,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
        );
        emit(const ForgotPasswordResetSuccess());
      } catch (e) {
        emit(ForgotPasswordError(message: e.toString()));
      }
    });
  }
}
