import 'package:chatbot/features/blocs/signup/signup_event.dart';
import 'package:chatbot/features/blocs/signup/signup_state.dart';
import 'package:chatbot/features/data/repositories/auth_repository.dart';

class SignipBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;
  
  SignipBloc({ required this.authRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignupSubmitted);
  }

  Future
}