

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniguard/services/database_service.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';

class AdminAddNotice extends StatefulWidget {
  final Map<String, dynamic>? notice; // edit mode er jonno

  const AdminAddNotice({Key? key, this.notice}) : super(key: key);

  @override
  State<AdminAddNotice> createState() => _AdminAddNoticeState();
}

class _AdminAddNoticeState extends State<AdminAddNotice> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  String _type = 'general';
  DateTime? _dueDate;

  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();

    // 🔹 EDIT MODE
    if (widget.notice != null) {
      _titleCtrl.text = widget.notice!['title'] ?? '';
      _contentCtrl.text = widget.notice!['content'] ?? '';
      _type = widget.notice!['type'] ?? 'general';

      if (widget.notice!['due_date'] != null) {
        _dueDate = DateTime.parse(widget.notice!['due_date']);
      }
    }
  }
  Future<void> _saveNotice() async {
    final user = Supabase.instance.client.auth.currentUser;
    print('USER = $user'); // 🔥 DEBUG LINE

    if (!_formKey.currentState!.validate()) return;

    if (_type == 'assignment' && _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select due date for assignment'),
        ),
      );
      return;
    }

    if (widget.notice == null) {
      await _db.createNotice(
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        type: _type,
        dueDate: _type == 'assignment' ? _dueDate : null,
      );
    } else {
      await _db.updateNotice(
        id: widget.notice!['id'],
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        type: _type,
        dueDate: _type == 'assignment' ? _dueDate : null,
      );
    }

    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.notice != null;

    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        title: Text(
          isEdit ? 'Edit Notice' : 'Add Notice',
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// 🔹 Title
              TextFormField(
                controller: _titleCtrl,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: AppTextStyles.bodyMedium,
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Content
              TextFormField(
                controller: _contentCtrl,
                maxLines: 4,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: AppTextStyles.bodyMedium,
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Type
              DropdownButtonFormField<String>(
                value: _type,
                dropdownColor: AppColors.cardGreen,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'general',
                    child: Text('General'),
                  ),
                  DropdownMenuItem(
                    value: 'assignment',
                    child: Text('Assignment'),
                  ),
                ],
                onChanged: (v) => setState(() => _type = v!),
              ),

              /// 🔹 Due Date (only assignment)
              if (_type == 'assignment') ...[
                const SizedBox(height: 16),
                ListTile(
                  tileColor: AppColors.cardGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    _dueDate == null
                        ? 'Select Due Date'
                        : _dueDate!.toLocal().toString().split(' ')[0],
                    style: AppTextStyles.bodyLarge,
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() => _dueDate = picked);
                    }
                  },
                ),
              ],

              const SizedBox(height: 24),

              /// 🔹 Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveNotice,
                  child: Text(
                    isEdit ? 'Update Notice' : 'Save Notice',
                    style: AppTextStyles.headingMedium,
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