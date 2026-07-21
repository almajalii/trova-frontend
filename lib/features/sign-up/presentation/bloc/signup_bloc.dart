import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/sign-up/logic/signup_model.dart';
import 'package:trova/features/sign-up/logic/signup_service.dart';
import 'package:trova/features/sign-up/presentation/bloc/signup_event.dart';
import 'package:trova/features/sign-up/presentation/bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupService signupService;

  SignupBloc({required this.signupService}) : super(const SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(const SignupLoading());

      try {
        final data = SignupData(
          firstName: event.firstName,
          lastName: event.lastName,
          workEmail: event.workEmail,
          phoneNumber: event.phoneNumber,
          password: event.password,
          confirmPassword: event.confirmPassword,
        );

        final result = await signupService.submitSignup(data);
        emit(SignupSuccess(result: result));
      } catch (e) {
        emit(SignupError(message: e.toString()));
      }
    });
  }
}
