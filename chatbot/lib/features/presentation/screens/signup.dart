import 'package:chatbot/features/blocs/login/login_bloc.dart';
import 'package:chatbot/features/blocs/login/login_state.dart';
import 'package:chatbot/features/blocs/signup/signup_bloc.dart';
import 'package:chatbot/features/blocs/signup/signup_event.dart';
import 'package:chatbot/features/blocs/signup/signup_state.dart';
import 'package:chatbot/features/presentation/widgets/custom_button.dart';
import 'package:chatbot/features/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            CustomTextField(
              controller: emailController,
              hintText: "Enter Email",
            ),
            SizedBox(height: 50),
            CustomTextField(
              controller: passwordController,
              hintText: "Enter Password",
              obscuredText: true,
            ),
            SizedBox(height: 50),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: "Re-Enter Password",
              obscuredText: true,
            ),

            SizedBox(height: 50),
            BlocListener<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state is SignUpFailure) {
                  Fluttertoast.showToast(msg: "Signup Failed");
                } else if (state is SignUpSuccess) {
                  Fluttertoast.showToast(msg: "Signup Successful");
                  context.go('/login'); // Now it will navigate properly
                }
              },
              child: CustomButton(
                text: "SignUp",
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Email or password cannot be Empty",
                    );
                    return;
                  }
                  if (password != confirmPassword) {
                    Fluttertoast.showToast(msg: "Password should be same");
                    return;
                  }

                  context.read<SignupBloc>().add(
                    SignUpSubmitted(email: email, password: password),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account"),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    "Login",
                    style: TextStyle(color: theme.colorScheme.tertiary!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
