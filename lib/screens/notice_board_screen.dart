import  'package:flutter/material.dart';
import 'package:uniguard/services/database_service.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({Key? key}) : super(key: key);

  @override
  _NoticeBoardScreenState createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  final _databaseService = DatabaseService();
  List<Map<String, dynamic>> _notices = [];

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    final notices = await _databaseService.getNotices();
    setState(() => _notices = notices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board'),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: _notices.isEmpty
          ? Center(
        child: Text(
          'No notices available',
          style: TextStyle(color: Colors.white54, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return Card(
            color: const Color(0xFF2E7D32),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getNoticeIcon(notice['type']),
                        color: const Color(0xFF81C784),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notice['created_at']?.substring(0, 10) ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    notice['content'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getNoticeIcon(String? type) {
    switch (type) {
      case 'exam':
        return Icons.school;
      case 'assignment':
        return Icons.assignment;
      case 'general':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }
}