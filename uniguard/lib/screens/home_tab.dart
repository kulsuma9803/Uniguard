import 'package:flutter/material.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';
import 'package:uniguard/utils/responsive.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,

      // 🔹 TOP HEADER
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryDarkGreen,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back", style: AppTextStyles.bodyMedium),
            Text("Student Dashboard", style: AppTextStyles.headingMedium),
          ],
        ),
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
              // 🔹 QUICK ACTIONS
              Text("Quick Actions", style: AppTextStyles.headingMedium),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickAction(
                    icon: Icons.assignment_add,
                    label: "Add\nAssignment",
                    onTap: () {
                      Navigator.pushNamed(context, '/assignments');
                    },
                  ),
                  _quickAction(
                    icon: Icons.campaign,
                    label: "Notices",
                    onTap: () {},
                  ),
                  _quickAction(icon: Icons.school, label: "Exam", onTap: () {}),
                  _quickAction(
                    icon: Icons.report_problem,
                    label: "Lost &\nFound",
                    onTap: () {
                      Navigator.pushNamed(context, '/lost_found');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 🔹 DASHBOARD MAIN CONTENT (SS STYLE)
              Text("Today Overview", style: AppTextStyles.headingMedium),
              const SizedBox(height: 12),

              _dashboardItem(
                icon: Icons.schedule,
                title: "Schedule",
                subtitle: "No classes today",
              ),
              _dashboardItem(
                icon: Icons.local_library,
                title: "Library Update",
                subtitle: "New books available",
              ),
              _dashboardItem(
                icon: Icons.restaurant,
                title: "Lunch Break",
                subtitle: "Cafeteria 1:00 PM – 2:00 PM",
              ),

              const SizedBox(height: 28),

              // 🔹 ASSIGNMENT SECTION (SS STYLE)
              Text("Recent Assignments", style: AppTextStyles.headingMedium),
              const SizedBox(height: 12),

              _assignmentItem(
                title: "Database Management System",
                deadline: "Due: 25 Feb 2026",
              ),
              _assignmentItem(
                title: "Object Oriented Programming",
                deadline: "Due: 28 Feb 2026",
              ),
              _assignmentItem(
                title: "Computer Networks",
                deadline: "Due: 02 Mar 2026",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 QUICK ACTION WIDGET
  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.lightGreen, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  // 🔹 DASHBOARD INFO ROW
  Widget _dashboardItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.lightGreen),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 ASSIGNMENT ITEM (SMALL & CLEAN)
  Widget _assignmentItem({required String title, required String deadline}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.assignment, color: Color(0xFF81C784)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge),
              const SizedBox(height: 4),
              Text(deadline, style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
