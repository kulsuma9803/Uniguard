

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniguard/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  File? _avatarImage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = _authService.getCurrentUser();
    _nameController.text = user?.userMetadata?['full_name'] ?? '';
  }

  /// 🔹 Image pick
  Future<void> _pickAvatar() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarImage = File(image.path);
      });
    }
  }

  /// 🔹 Save profile
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      String? avatarUrl;

      /// 1️⃣ Upload avatar (if selected)
      if (_avatarImage != null) {
        avatarUrl = await _authService.uploadAvatar(_avatarImage!);
      }

      /// 2️⃣ Update profile
      await _authService.updateProfile(
        fullName: _nameController.text.trim(),
        avatarUrl: avatarUrl,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3B13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// 🔹 Avatar
              GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xFF81C784),
                  backgroundImage:
                  _avatarImage != null ? FileImage(_avatarImage!) : null,
                  child: _avatarImage == null
                      ? const Icon(Icons.camera_alt,
                      size: 30, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 Full name
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF81C784)),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 32),

              /// 🔹 Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81C784),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Save Changes',
                    style:
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}