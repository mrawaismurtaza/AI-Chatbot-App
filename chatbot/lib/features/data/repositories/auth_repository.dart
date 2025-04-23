import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatbot/features/data/models/user_model.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  

  Future<void> signUp(UserModel user) async {
  try {
    final response = await supabase.auth.signUp(
      email: user.email,
      password: user.password,
    );

    final newUser = response.user;

    if (newUser == null) {
      throw Exception('Signup failed: No user returned');
    }

    await supabase.from('users').insert(user.toMap(userId: newUser.id));
  } catch (e) {
    rethrow;
  }
}

  Future<void> login({required String email, required String password}) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Login failed: No user returned');
    }
  }

  Future<void> saveOtp({
    required String email,
    required String otp,
    required String expiresAt,
  }) async {
    await supabase.from('password_reset_tokens').insert({
      'email': email,
      'otp': otp,
      'expires_at': expiresAt,
    });
  }

  Future<void> verifyOtpAndUpdatePassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final token = await supabase
        .from('password_reset_tokens')
        .select()
        .eq('email', email)
        .eq('otp', otp)
        .order('expires_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (token == null ||
        DateTime.parse(token['expires_at']).isBefore(DateTime.now())) {
      throw Exception('Invalid or expired OTP');
    }

    await supabase.rpc(
      'update_user_password',
      params: {
        'user_email': email,
        'new_plain_password': newPassword,
      },
    );
  }
}
