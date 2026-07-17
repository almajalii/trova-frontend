import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/log-in/logic/biometric_login_service.dart';
import 'package:trova/features/log-in/logic/login_model.dart';
import 'package:trova/features/log-in/logic/login_service.dart';
import 'package:trova/features/log-in/presentation/bloc/login_event.dart';
import 'package:trova/features/log-in/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginService loginService;
  final BiometricLoginService biometricLoginService;

  LoginBloc({required this.loginService, required this.biometricLoginService})
      : super(const LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(const LoginLoading());

      try {
        final data = LoginData(email: event.email, password: event.password);
        final result = await loginService.submitLogin(data);
        emit(LoginSuccess(result: result));
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    });

    on<BiometricLoginRequested>((event, emit) async {
      emit(const LoginLoading());

      try {
        final result = await biometricLoginService.unlockWithBiometrics();
        emit(LoginSuccess(result: result));
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    });
  }
}
