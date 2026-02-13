
import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniguard/main.dart';

class DatabaseService {
  final _supabase = supabase;

  /// ===================== NOTICES =====================

  Future<List<Map<String, dynamic>>> getNotices() async =>
      List<Map<String, dynamic>>.from(
        await _supabase
            .from('notices')
            .select()
            .order('created_at', ascending: false),
      );

  Future<void> createNotice({
    required String title,
    required String content,
    required String type,
    DateTime? dueDate,
  }) async {
    try {
      final res = await _supabase.from('notices').insert({
        'title': title,
        'content': content,
        'type': type,
        'due_date': dueDate?.toIso8601String(),
      }).select();

      print('INSERT SUCCESS: $res');
    } catch (e) {
      print('INSERT ERROR: $e');
    }
  }

  Future<void> updateNotice({
    required int id,
    required String title,
    required String content,
    required String type,
    DateTime? dueDate,
  }) async {
    await _supabase.from('notices').update({
      'title': title,
      'content': content,
      'type': type,
      'due_date': dueDate?.toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteNotice(int id) async =>
      await _supabase.from('notices').delete().eq('id', id);

  Future<List<Map<String, dynamic>>> getAssignmentNotices() async {
    final data = await _supabase
        .from('notices')
        .select()
        .eq('type', 'assignment')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data as List);
  }

  /// ===================== ASSIGNMENTS =====================

  Future<List<Map<String, dynamic>>> getAssignments() async =>
      List<Map<String, dynamic>>.from(
        await _supabase
            .from('assignments')
            .select()
            .eq('user_id', _supabase.auth.currentUser!.id)
            .order('created_at', ascending: false),
      );

  Future<void> createAssignment(
      String title,
      String description,
      DateTime deadline,
      ) async =>
      await _supabase.from('assignments').insert({
        'user_id': _supabase.auth.currentUser!.id,
        'title': title,
        'description': description,
        'deadline': deadline.toIso8601String(),
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });

  Future<void> submitAssignment(
      int id,
      Uint8List fileBytes,
      String fileName,
      ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw 'User not logged in';

    final finalFileName =
        '${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _supabase.storage.from('assignments_files').uploadBinary(
      finalFileName,
      fileBytes,
      fileOptions: FileOptions(
        cacheControl: '3600',
        upsert: true,
        metadata: {'owner_id': user.id},
      ),
    );

    final fileUrl = _supabase.storage
        .from('assignments_files')
        .getPublicUrl(finalFileName);

    await _supabase.from('assignments').update({
      'file_url': fileUrl,
      'submitted_at': DateTime.now().toIso8601String(),
      'status': 'done',
    }).eq('id', id);
  }

  /// ===================== LOST & FOUND =====================

  Future<List<Map<String, dynamic>>> getLostItems() async =>
      List<Map<String, dynamic>>.from(
        await _supabase
            .from('lost_items')
            .select()
            .order('created_at', ascending: false),
      );

  Future<void> createLostItem(
      String title,
      String description,
      String location,
      String imageUrl,
      ) async =>
      await _supabase.from('lost_items').insert({
        'user_id': _supabase.auth.currentUser!.id,
        'title': title,
        'description': description,
        'location': location,
        'image_url': imageUrl,
        'status': 'lost',
        'created_at': DateTime.now().toIso8601String(),
      });

  Future<void> updateLostItemStatus(int id, String status) async =>
      await _supabase
          .from('lost_items')
          .update({'status': status})
          .eq('id', id);

  Future<void> updateLostItem(
      int id,
      String title,
      String description,
      String location,
      String imageUrl,
      ) async {
    await _supabase.from('lost_items').update({
      'title': title,
      'description': description,
      'location': location,
      'image_url': imageUrl,
    }).eq('id', id);
  }

  Future<void> deleteLostItem(int id) async =>
      await _supabase.from('lost_items').delete().eq('id', id);

  /// ===================== USERS (ADMIN) =====================


  Future<List<Map<String, dynamic>>> getAllUsers() async =>
  List<Map<String, dynamic>>.from(
  await _supabase
      .from('profiles')
      .select(
  'id, full_name, email, student_id, role, active, last_login, created_at',
  )
      .order('created_at', ascending: false),
  );

  Future<void> updateUserRole(
  String userId,
  String newRole,
  ) async =>
  await _supabase
      .from('profiles')
      .update({'role': newRole})
      .eq('id', userId);

  /// 🔴 NEW: Activate / Block User
  Future<void> updateUserStatus(String userId, bool active) async =>
  await _supabase
      .from('profiles')
      .update({'active': active})
      .eq('id', userId);

  // ================= SYSTEM LOGS =================

  Future<List<Map<String, dynamic>>> getSystemLogs() async =>
  List<Map<String, dynamic>>.from(
  await _supabase
      .from('system_logs')
      .select()
      .order('created_at', ascending: false)
      .limit(100),
  );

  Future<void> logEvent(String event, String details) async =>
  await _supabase.from('system_logs').insert({
  'event': event,
  'details': details,
  'created_at': DateTime.now().toIso8601String(),
  });
  }
