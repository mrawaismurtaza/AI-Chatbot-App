import 'package:chatbot/features/presentation/widgets/custom_button.dart';
import 'package:chatbot/features/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField( controller: emailController, hintText: "Enter Email"),
              SizedBox(height: 40),
              CustomTextField( controller: passwordController, hintText: "Enter Password",
              ),
              SizedBox(height: 40),
              CustomButton( text: "Login",
                onPressed: () { 
                  Fluttertoast.showToast(msg: "Login Successfull");
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account"),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: theme.colorScheme.tertiary!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
