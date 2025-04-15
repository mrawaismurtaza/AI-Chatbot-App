import 'package:chatbot/features/presentation/widgets/custom_button.dart';
import 'package:chatbot/features/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController confirmPasswordController = TextEditingController();

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
            CustomTextField(controller: emailController, hintText: "Enter Email"),
            SizedBox(height: 50),
            CustomTextField(controller: passwordController, hintText: "Enter Password"),
            SizedBox(height: 50),
            CustomTextField(controller: confirmPasswordController, hintText: "Re-Enter Password"),
            SizedBox(height: 50),
            CustomButton(text: "Signup", onPressed: () {
              Fluttertoast.showToast(msg: "SignUp Successfull");
            }),
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