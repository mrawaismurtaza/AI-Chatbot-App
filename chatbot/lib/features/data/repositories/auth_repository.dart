import 'package:chatbot/features/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Login failed: No user returned');
    }
    print('Login successful: ${user.email}');
  } catch (e) {
    print('Login failed: $e');
    rethrow;
  }
}

}