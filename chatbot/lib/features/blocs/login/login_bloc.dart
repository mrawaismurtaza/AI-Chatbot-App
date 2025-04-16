import 'package:chatbot/features/blocs/login/login_event.dart';
import 'package:chatbot/features/blocs/login/login_state.dart';
import 'package:chatbot/features/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.login(
          email: event.email,
          password: event.password,
        );
        print("Login success: Emitting LoginSuccess");
        emit(LoginSuccess());
      } catch (e) {
        print("Login failed: $e");
        String errorMessage = 'Login failed. Please try again.';
        if (e.toString().contains('SocketException')) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else if (e.toString().contains('Invalid login credentials')) {
          errorMessage = 'Invalid email or password.';
        }
        emit(LoginFailure(errorMessage));
      }
    });
  }
}