import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getProfile(String userId) async {
    final data =
        await supabase.from('users').select().eq('id', userId).single();

    return data;
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await supabase.from('users').update(data).eq('id', userId);
  }

  Future<Map<String, dynamic>> updateProfilePicture(
    String userId,
    File image,
  ) async {
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '/$userId/$imageName';
    final bytes = await image.readAsBytes();

    try {
      await supabase.storage
          .from('profile-pictures')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'),
          );

      final publicUrl = supabase.storage
          .from('profile-pictures')
          .getPublicUrl(filePath);

      await updateProfile(userId, {'profile_pic': publicUrl});
      return await getProfile(userId);
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }
}
