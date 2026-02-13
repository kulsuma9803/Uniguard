
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniguard/main.dart';

class AuthService {
  final _supabase = supabase;

  Future<AuthResponse?> signUp(String email, String password, String fullName, String studentId) async {
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'student_id': studentId, 'role': 'student'},
      );
      if (res.user != null) {
        await _supabase.from('profiles').insert({
          'id': res.user!.id,
          'full_name': fullName,
          'student_id': studentId,
          'email': email,
          'role': 'student',
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      return res;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  Future<AuthResponse?> signIn(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  User? getCurrentUser() => _supabase.auth.currentUser;
  bool isAdmin() => getCurrentUser()?.userMetadata?['role'] == 'admin';

  Future<String?> uploadAvatar(File image) async {
    final user = getCurrentUser();
    if (user == null) return null;

    final filePath = 'avatars/${user.id}.jpg';

    await _supabase.storage.from('avatars').upload(
      filePath,
      image,
      fileOptions: const FileOptions(upsert: true),
    );

    /// Public URL
    final imageUrl =
    _supabase.storage.from('avatars').getPublicUrl(filePath);

    return imageUrl;
  }

  /// 🔹 Update profile metadata
  Future<void> updateProfile({
    required String fullName,
    String? avatarUrl,
  }) async {
    final updates = {
      'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };

    await _supabase.auth.updateUser(
      UserAttributes(data: updates),
    );
  }

  /// 🔹 Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}









