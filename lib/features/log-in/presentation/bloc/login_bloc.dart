import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/log-in/logic/login_model.dart';
import 'package:trova/features/log-in/logic/login_service.dart';
import 'package:trova/features/log-in/presentation/bloc/login_event.dart';
import 'package:trova/features/log-in/presentation/bloc/login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginService loginService;

  LoginBloc({required this.loginService}) : super(const LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(const LoginLoading());

      try {
        final data = LoginData(email: event.email, password: event.password);
        await loginService.submitLogin(data);
        emit(const LoginSuccess());
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    });
  }
}