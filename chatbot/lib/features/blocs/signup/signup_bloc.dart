import 'package:chatbot/features/blocs/signup/signup_event.dart';
import 'package:chatbot/features/blocs/signup/signup_state.dart';
import 'package:chatbot/features/data/models/user_model.dart';
import 'package:chatbot/features/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>((event, emit) async {
      emit(SingUpLoading());

      try{
        final user = UserModel(email: event.email, password: event.password, username: "", profilepic: "");

        await authRepository.signUp(user);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure(e.toString()));
      }
    });
  }
}