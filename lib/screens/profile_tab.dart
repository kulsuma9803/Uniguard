
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uniguard/services/auth_service.dart';
import 'package:uniguard/screens/edit_profile_screen.dart';
import 'package:uniguard/screens/my_posts_screen.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthService _authService = AuthService();
  File? _avatarImage;
  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final imageFile = File(picked.path);

    setState(() {
      _avatarImage = imageFile;
    });

    await _authService.uploadAvatar(imageFile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avatar updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    final avatarUrl = user?.userMetadata?['avatar_url'];

    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        title: Text('Profile', style: AppTextStyles.headingMedium),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.lightGreen,
                      backgroundImage: _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : (avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null) as ImageProvider?,
                      child: (_avatarImage == null && avatarUrl == null)
                          ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B5E20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(
                user?.userMetadata?['full_name'] ?? 'User',
                style: AppTextStyles.headingLarge,
              ),
              Text(
                user?.email ?? '',
                style: AppTextStyles.bodyMedium,
              ),

              const SizedBox(height: 24),

              _infoCard(
                'Student ID',
                user?.userMetadata?['student_id'] ?? 'N/A',
              ),
              const SizedBox(height: 12),
              _infoCard(
                'Email',
                user?.email ?? 'N/A',
              ),

              const SizedBox(height: 24),

              /// 🔹 MY POSTS
              _actionButton(
                icon: Icons.article,
                label: 'My Posts',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyPostsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              /// 🔹 EDIT PROFILE
              _actionButton(
                icon: Icons.edit,
                label: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              /// 🔹 LOGOUT (Spacer REMOVED)
              _actionButton(
                icon: Icons.logout,
                label: 'Logout',
                color: Colors.redAccent,
                onTap: () async {
                  await _authService.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (_) => false,
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 INFO CARD
  Widget _infoCard(String title, String value) {
    return Card(
      color: AppColors.cardGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(title, style: AppTextStyles.bodyMedium),
        subtitle: Text(value, style: AppTextStyles.bodyLarge),
      ),
    );
  }

  /// 🔹 ACTION BUTTON
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.lightGreen,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}