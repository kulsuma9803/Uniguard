
import 'package:flutter/material.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';
import 'package:uniguard/services/database_service.dart';

class AdminManageUsers extends StatefulWidget {
  const AdminManageUsers({Key? key}) : super(key: key);

  @override
  State<AdminManageUsers> createState() => _AdminManageUsersState();
}

class _AdminManageUsersState extends State<AdminManageUsers> {
  final DatabaseService _db = DatabaseService();

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchCtrl.addListener(_filterUsers);
  }

  Future<void> _loadUsers() async {
    try {
      final data = await _db.getAllUsers();
      setState(() {
        _allUsers = data;
        _filteredUsers = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading users: $e')),
      );
    }
  }

  void _filterUsers() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((u) {
        final name = (u['full_name'] ?? '').toLowerCase();
        final email = (u['email'] ?? '').toLowerCase();
        final id = (u['student_id'] ?? '').toLowerCase();
        return name.contains(q) || email.contains(q) || id.contains(q);
      }).toList();
    });
  }

  Future<void> _changeRole(String userId, String role) async {
    await _db.updateUserRole(userId, role);
    _loadUsers();
  }

  Future<void> _toggleStatus(String userId, bool active) async {
    await _db.updateUserStatus(userId, active);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        title: Text('Manage Users', style: AppTextStyles.headingMedium),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          /// 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by name, email or ID',
                filled: true,
                fillColor: AppColors.cardGreen,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// 👥 USERS
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
              child: Text(
                'No users found',
                style: AppTextStyles.bodyLarge,
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredUsers.length,
              itemBuilder: (_, i) {
                final u = _filteredUsers[i];

                final name = u['full_name'] ?? 'Unknown';
                final email = u['email'] ?? 'N/A';
                final sid = u['student_id'] ?? 'N/A';
                final role = u['role'] ?? 'student';
                final active = u['active'] ?? true;
                final lastLogin = u['last_login'] ?? 'N/A';

                return Card(
                  color: AppColors.cardGreen,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lightGreen,
                      child: Text(
                        name.isNotEmpty
                            ? name[0].toUpperCase()
                            : '?',
                        style:
                        const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(name,
                        style: AppTextStyles.bodyLarge),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(email,
                            style: AppTextStyles.caption),
                        Text('ID: $sid',
                            style: AppTextStyles.caption),
                        Text('Role: $role',
                            style: AppTextStyles.caption),
                        Text('Last login: $lastLogin',
                            style: AppTextStyles.caption),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          color: Colors.white),
                      onSelected: (value) {
                        if (value == 'block') {
                          _toggleStatus(u['id'], false);
                        } else if (value == 'activate') {
                          _toggleStatus(u['id'], true);
                        } else {
                          _changeRole(u['id'], value);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: role == 'admin'
                              ? 'student'
                              : 'admin',
                          child: Text(
                            role == 'admin'
                                ? 'Make Student'
                                : 'Make Admin',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'activate',
                          child: Text('Activate'),
                        ),
                        const PopupMenuItem(
                          value: 'block',
                          child: Text('Block'),
                        ),
                      ],
                    ),
                    enabled: active,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
