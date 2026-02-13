import 'package:flutter/material.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';
import 'package:uniguard/screens/admin_add_notice.dart';
import 'package:uniguard/screens/admin_manage_users.dart';
import 'package:uniguard/screens/admin_system_logs.dart';
import 'package:uniguard/screens/admin_profile_screen.dart';
import 'package:uniguard/utils/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        elevation: 0,
        title: Text('Admin Panel', style: AppTextStyles.headingMedium),
        actions: [
          /// 👤 Profile Button
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
              );
            },
          ),

          /// 🚪 Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lightGreen,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminAddNotice()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: 16,
        ),
        child: ResponsiveCenter(
          maxWidth: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔰 HEADER / WELCOME CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDarkGreen, AppColors.cardGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Administrator',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 📊 STATS CARDS
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'Students',
                      value: '1204',
                      icon: Icons.people,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: 'Notices',
                      value: '12',
                      icon: Icons.campaign,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: 'Pending',
                      value: '5',
                      icon: Icons.warning,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// ⚡ QUICK ACTIONS (Mini Boxes)
              Text('Quick Actions', style: AppTextStyles.headingMedium),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0, // mini square
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _miniQuickAction(
                    title: 'Notices',
                    icon: Icons.campaign,
                    color: Colors.greenAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminAddNotice()),
                    ),
                  ),
                  _miniQuickAction(
                    title: 'Users',
                    icon: Icons.people,
                    color: Colors.purpleAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminManageUsers(),
                      ),
                    ),
                  ),
                  _miniQuickAction(
                    title: 'Reports',
                    icon: Icons.analytics,
                    color: Colors.blueAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminSystemLogs(),
                      ),
                    ),
                  ),
                  _miniQuickAction(
                    title: 'Logs',
                    icon: Icons.history,
                    color: Colors.orangeAccent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminSystemLogs(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// 🕒 RECENT LOGS (STATIC EXAMPLE)
              Text('Recent System Logs', style: AppTextStyles.headingMedium),
              const SizedBox(height: 12),

              _logTile(
                icon: Icons.check_circle,
                title: 'New Notice: Semester Final',
                subtitle: 'Posted by Admin • 2 mins ago',
                color: AppColors.lightGreen,
              ),
              _logTile(
                icon: Icons.report,
                title: 'Spam Content Detected',
                subtitle: 'System Alert • 1 hour ago',
                color: Colors.orange,
              ),
              _logTile(
                icon: Icons.update,
                title: 'Routine Updated: CS-101',
                subtitle: 'Updated • 3 hours ago',
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===================== WIDGETS =====================

  static Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.lightGreen),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.headingLarge),
          Text(title, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  /// 🔹 Mini Quick Action Box
  static Widget _miniQuickAction({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.cardGreen,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _logTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      color: AppColors.cardGreen,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: AppTextStyles.bodyMedium),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
      ),
    );
  }
}
