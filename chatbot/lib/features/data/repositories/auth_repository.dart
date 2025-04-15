import 'package:chatbot/features/data/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  Future<void> signUp(UserModel user) async{
    try {
      final response = await supabase.auth.signUp(
        email: user.email,
        password: user.password,
      );

      final newUser = response.user;
      if(newUser == null) {
        Fluttertoast.showToast(msg: "Try Again");
        return;
      }
      
      await supabase.from('users').insert(user.toMap(userId: newUser.id));

      Fluttertoast.showToast(msg: "SignUp Successfull");
    } catch (e){
      Fluttertoast.showToast(msg: "Try Again");
      rethrow;
    }
  }
}