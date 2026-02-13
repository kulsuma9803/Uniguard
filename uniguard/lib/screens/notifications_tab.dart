/*import 'package:flutter/material.dart';
import 'package:uniguard/services/database_service.dart';

class NotificationsTab extends StatefulWidget {
  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  final _databaseService = DatabaseService();
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    // Combine different notification types
    final notices = await _databaseService.getNotices();
    final assignments = await _databaseService.getAssignments();

    List<Map<String, dynamic>> notifications = [];

    // Add notices as notifications
    notifications.addAll(notices.map((notice) => {
      'id': 'notice_${notice['id']}',
      'type': 'notice',
      'title': notice['title'],
      'message': notice['content'],
      'time': notice['created_at'],
      'icon': Icons.campaign,
      'read': false,
    }).toList());

    // Add assignment reminders
    notifications.addAll(assignments.where((a) => a['status'] == 'pending').map((assignment) => {
      'id': 'assignment_${assignment['id']}',
      'type': 'assignment',
      'title': 'Assignment Due',
      'message': '${assignment['title']} is due soon',
      'time': assignment['deadline'],
      'icon': Icons.assignment,
      'read': false,
    }).toList());

    setState(() {
      _notifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF1B5E20),
      ),
      body: _notifications.isEmpty
          ? Center(
        child: Text(
          'No notifications',
          style: TextStyle(color: Colors.white54, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            color: notification['read'] ? Color(0xFF1B5E20) : Color(0xFF2E7D32),
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFF81C784),
                child: Icon(
                  notification['icon'] as IconData,
                  color: Colors.white,
                ),
              ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text(
                notification['message'],
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                _formatTime(notification['time']),
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return '';
    try {
      final dateTime = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }
}*/
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