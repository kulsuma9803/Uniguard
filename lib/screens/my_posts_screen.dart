import 'dart:io'; // ✅ শীর্ষে যোগ করো
import 'package:flutter/material.dart';
import 'package:uniguard/services/database_service.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({Key? key}) : super(key: key);

  @override
  _MyPostsScreenState createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final _databaseService = DatabaseService();
  List<Map<String, dynamic>> _assignments = [];
  List<Map<String, dynamic>> _lostItems = [];

  @override
  void initState() {
    super.initState();
    _loadMyPosts();
  }

  Future<void> _loadMyPosts() async {
    final assignments = await _databaseService.getAssignments();
    final lostItems = await _databaseService.getLostItems();
    setState(() {
      _assignments = assignments;
      _lostItems = lostItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Posts'),
          backgroundColor: const Color(0xFF1B5E20),
          bottom: const TabBar(
            labelColor: Color(0xFF81C784),
            unselectedLabelColor: Colors.white54,
            indicatorColor: Color(0xFF81C784),
            tabs: [
              Tab(text: 'Assignments'),
              Tab(text: 'Lost Items'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAssignmentsTab(),
            _buildLostItemsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    return _assignments.isEmpty
        ? const Center(
      child: Text(
        'No assignments posted',
        style: TextStyle(color: Colors.white54, fontSize: 18),
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _assignments.length,
      itemBuilder: (context, index) {
        final assignment = _assignments[index];
        return Card(
          color: const Color(0xFF2E7D32),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              assignment['title'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              assignment['description'],
              style: const TextStyle(color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: assignment['status'] == 'pending'
                    ? Colors.orange
                    : Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                assignment['status'] ?? 'pending',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLostItemsTab() {
    return _lostItems.isEmpty
        ? const Center(
      child: Text(
        'No lost items posted',
        style: TextStyle(color: Colors.white54, fontSize: 18),
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lostItems.length,
      itemBuilder: (context, index) {
        final item = _lostItems[index];
        return Card(
          color: const Color(0xFF2E7D32),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: (item['image_url'] != null &&
                item['image_url'].isNotEmpty)
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(item['image_url']), // ✅ File import fixed
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image,
                    color: Colors.white54),
              ),
            )
                : const Icon(Icons.image_not_supported,
                color: Colors.white54),
            title: Text(
              item['title'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Location: ${item['location']}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item['status'] == 'lost'
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['status'] ?? 'lost',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}