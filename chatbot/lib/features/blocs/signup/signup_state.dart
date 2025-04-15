abstract class SignupState {}

class SignUpInitial extends SignupState {}

class SingUpLoading extends SignupState {}

class SignUpSuccess extends SignupState {}

class SignUpFailure extends SignupState {
  final String message;
  SignUpFailure(this.message);
}