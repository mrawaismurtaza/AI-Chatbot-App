class UserModel {
  final String email;
  final String password;
  final String username;
  final String profilepic;

  UserModel({required this.email,required this.password,required this.username, required this.profilepic});

  Map<String, dynamic> toMap({required String userId}) {
    return {
      'id': userId,
      'name': username,
      'profile_pic': null,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}