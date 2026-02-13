



import 'package:flutter/material.dart';
import 'package:uniguard/services/database_service.dart';
import 'package:uniguard/constants/app_colors.dart';
import 'package:uniguard/constants/app_text_styles.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDarkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        title: Text('Search', style: AppTextStyles.headingMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search anything...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white12,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (query) {},
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _categoryCard(context, 'Assignments', Icons.assignment, '/assignments')),
                const SizedBox(width: 12),
                Expanded(child: _categoryCard(context, 'Exams', Icons.school, '/exams')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _categoryCard(context, 'Notices', Icons.campaign, '/notices')),
                const SizedBox(width: 12),
                Expanded(child: _categoryCard(context, 'Lost & Found', Icons.find_in_page, '/lost_found')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      color: AppColors.cardGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: AppColors.lightGreen),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}