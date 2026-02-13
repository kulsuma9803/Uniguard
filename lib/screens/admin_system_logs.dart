import 'package:flutter/material.dart';
import 'package:uniguard/services/database_service.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';

class AdminSystemLogs extends StatefulWidget {
  const AdminSystemLogs({Key? key}) : super(key: key);

  @override
  _AdminSystemLogsState createState() => _AdminSystemLogsState();
}

class _AdminSystemLogsState extends State<AdminSystemLogs> {
  final _db = DatabaseService();
  List<Map<String, dynamic>> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final data = await _db.getSystemLogs();
    setState(() => _logs = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(backgroundColor: AppColors.primaryDarkGreen, title: Text('System Logs', style: AppTextStyles.headingMedium)),
      body: _logs.isEmpty
          ? Center(child: Text('No logs', style: AppTextStyles.bodyLarge))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _logs.length,
        itemBuilder: (_, i) {
          final log = _logs[i];
          return Card(
            color: AppColors.cardGreen,
            child: ListTile(
              leading: Icon(
                log['event'] == 'login_success' ? Icons.check_circle : Icons.error,
                color: log['event'] == 'login_success' ? AppColors.lightGreen : Colors.red,
              ),
              title: Text(log['event'], style: AppTextStyles.bodyLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log['details'], style: AppTextStyles.bodyMedium),
                  Text(log['created_at']?.substring(0, 16) ?? '', style: AppTextStyles.caption),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}