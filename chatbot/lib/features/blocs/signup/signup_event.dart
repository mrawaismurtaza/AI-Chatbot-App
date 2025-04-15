abstract class SignupEvent {}

class SignUpSubmitted extends SignupEvent {
  final String email;
  final String password;

  SignUpSubmitted({required this.email, required this.password});
}