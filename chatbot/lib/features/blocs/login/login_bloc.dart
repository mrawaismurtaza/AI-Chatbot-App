import 'package:chatbot/features/blocs/login/login_event.dart';
import 'package:chatbot/features/blocs/login/login_state.dart';
import 'package:chatbot/features/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc< LoginEvent, LoginState>{
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super (LoginInitial()) {
    on<LoginSubmitted>((event, emit) async{
      emit(LoginLoading());

      try {
        await authRepository.login(
          email: event.email, 
          password: event.password,
        );
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }

}