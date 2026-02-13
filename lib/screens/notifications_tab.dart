
import 'package:flutter/material.dart';
import 'package:uniguard/services/database_service.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';
import 'package:intl/intl.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  final _db = DatabaseService();
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await _db.getNotices(); // notices as notifications
    setState(() => _notifications = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(backgroundColor: AppColors.primaryDarkGreen, title: Text('Notifications', style: AppTextStyles.headingMedium)),
      body: _notifications.isEmpty
          ? Center(child: Text('No notifications', style: AppTextStyles.bodyLarge))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (_, i) {
          final notif = _notifications[i];
          return Card(
            color: AppColors.cardGreen,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(_getIcon(notif['type']), color: AppColors.lightGreen),
              title: Text(notif['title'], style: AppTextStyles.bodyLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif['content'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium),
                  Text(DateFormat('MMM dd, HH:mm').format(DateTime.parse(notif['created_at'])), style: AppTextStyles.caption),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'exam':
        return Icons.school;
      case 'assignment':
        return Icons.assignment;
      case 'general':
      default:
        return Icons.campaign;
    }
  }
}