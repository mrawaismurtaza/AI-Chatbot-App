import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:chatbot/features/data/repositories/auth_repository.dart';
import 'package:chatbot/features/presentation/widgets/custom_button.dart';
import 'package:chatbot/features/presentation/widgets/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  String generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> _sendOtp() async {
    final email = emailController.text.trim();
    final otp = generateOtp();
    final expiresAt =
        DateTime.now().add(const Duration(minutes: 15)).toIso8601String();
    final formattedTime = TimeOfDay.fromDateTime(
      DateTime.now().add(const Duration(minutes: 15)),
    ).format(context);

    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your email');
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthRepository().saveOtp(email: email, otp: otp, expiresAt: expiresAt);

      const serviceId = 'aichatbot-service';
      const templateId = 'aichatbot-template';
      final publicKey = dotenv.env['EMAILJS_KEY']!;

      final emailResponse = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'email': email,
            'passcode': otp,
            'time': formattedTime,
          },
        }),
      );

      if (emailResponse.statusCode != 200) {
        throw Exception('Failed to send OTP via EmailJS');
      }

      Fluttertoast.showToast(msg: 'OTP sent to $email');
      _showResetPasswordDialog(email);
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error: ${error.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showResetPasswordDialog(String email) {
    final otpController = TextEditingController();
    final passwordController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Reset Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: otpController,
                    hintText: "Enter OTP",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "New Password",
                    obscuredText: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final otp = otpController.text.trim();
                    final newPassword = passwordController.text.trim();

                    if (otp.isEmpty || newPassword.isEmpty) {
                      Fluttertoast.showToast(msg: 'Enter OTP and password');
                      return;
                    }

                    setState(() => isSubmitting = true);

                    try {
                      await AuthRepository().verifyOtpAndUpdatePassword(
                        email: email,
                        otp: otp,
                        newPassword: newPassword,
                      );

                      Fluttertoast.showToast(
                        msg: 'Password updated successfully',
                      );
                      context.go('/login');
                    } catch (error) {
                      Fluttertoast.showToast(msg: 'Error: ${error.toString()}');
                    } finally {
                      setState(() => isSubmitting = false);
                    }
                  },
                  child: isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Confirm'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.1,
          vertical: height * 0.25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Enter your email to receive a reset OTP.'),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              hintText: "Enter Email",
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: isLoading ? "Sending..." : "Send OTP",
              onPressed: _sendOtp,
            ),
            const SizedBox(height: 20),
            CustomButton(text: 'Back', onPressed: () {
              context.go('/login');
            }),
          ],
        ),
      ),
    );
  }
}
