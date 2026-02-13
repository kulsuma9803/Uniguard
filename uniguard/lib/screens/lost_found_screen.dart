

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniguard/services/database_service.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';
import 'package:uniguard/services/image_picker_service.dart';

class LostFoundScreen extends StatefulWidget {
  const LostFoundScreen({Key? key}) : super(key: key);

  @override
  _LostFoundScreenState createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  final _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  final ImagePickerService imageService = ImagePickerService();
  String? _selectedImageUrl;
  List<Map<String, dynamic>> _items = [];

  bool _isUpdating = false;
  int? _updatingItemId;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await _db.getLostItems();
    setState(() => _items = data);
  }

  Future<void> _pickAndUploadImage() async {
    final picked = await imageService.pickImageFromGallery();
    if (picked != null) {
      final url = await imageService.uploadImage(picked);
      if (url != null) {
        setState(() => _selectedImageUrl = url);
      }
    }
  }

  Future<void> _postItem() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isUpdating && _updatingItemId != null) {
      // Update logic
      await _db.updateLostItemStatus(
        _updatingItemId!,
        _selectedImageUrl != null ? 'updated' : 'lost',
      );
      // Optional: update title, description, location
      await _db.updateLostItem(
        _updatingItemId!,
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _locationController.text.trim(),
        _selectedImageUrl ?? '',
      );
    } else {
      // Create new item
      await _db.createLostItem(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _locationController.text.trim(),
        _selectedImageUrl ?? '',
      );
    }

    _clearForm();
    _loadItems();
    Navigator.pop(context);
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _selectedImageUrl = null;
    _isUpdating = false;
    _updatingItemId = null;
  }

  Future<void> _deleteItem(int id, String? imageUrl) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final fileName = imageUrl.split('/').last;
      await imageService.deleteImage(fileName);
    }
    await _db.deleteLostItem(id);
    _loadItems();
  }

  void _showPostDialog({Map<String, dynamic>? item}) {
    if (item != null) {
      _isUpdating = true;
      _updatingItemId = item['id'];
      _titleController.text = item['title'];
      _descriptionController.text = item['description'];
      _locationController.text = item['location'];
      _selectedImageUrl = item['image_url'];
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardGreen,
        title: Text(
          _isUpdating ? 'Update Item' : 'Post Lost/Found Item',
          style: AppTextStyles.headingMedium,
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedImageUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _selectedImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Image.asset('assets/images/no_image.png'),
                      ),
                    )
                        : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo,
                            color: Color(0xFF81C784), size: 32),
                        Text('Add Photo',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.white70)),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white70)),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(color: Colors.white70)),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child:
              const Text('Cancel', style: TextStyle(color: Colors.white70))),
          ElevatedButton(
            onPressed: _postItem,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.lightGreen),
            child: Text(_isUpdating ? 'Update' : 'Post',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Image.asset('assets/images/no_image.png', width: 50, height: 50),
        ),
      );
    } else {
      return Image.asset(
        'assets/images/no_image.png',
        width: 50,
        height: 50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(
          backgroundColor: AppColors.primaryDarkGreen,
          title: Text('Lost & Found', style: AppTextStyles.headingMedium)),
      body: _items.isEmpty
          ? Center(child: Text('No items posted', style: AppTextStyles.bodyLarge))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          return Card(
            color: AppColors.cardGreen,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: _buildItemImage(item['image_url']),
              title: Text(item['title'], style: AppTextStyles.bodyLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium),
                  Text('Location: ${item['location']}',
                      style: TextStyle(color: AppColors.lightGreen)),
                ],
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () => Future.delayed(
                        const Duration(milliseconds: 0),
                            () => _showPostDialog(item: item)),
                  ),
                  if (item['status'] == 'lost')
                    PopupMenuItem(
                        child: const Text('Mark as Found'),
                        onTap: () => _db.updateLostItemStatus(
                            item['id'], 'found').then((_) => _loadItems())),
                  if (item['status'] == 'found')
                    PopupMenuItem(
                        child: const Text('Mark as Lost'),
                        onTap: () => _db.updateLostItemStatus(
                            item['id'], 'lost').then((_) => _loadItems())),
                  PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () =>
                          _deleteItem(item['id'], item['image_url'])),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostDialog(),
        backgroundColor: AppColors.lightGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}