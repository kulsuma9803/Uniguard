

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import '../services/database_service.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final supabase = Supabase.instance.client;
  final DatabaseService db = DatabaseService();

  Future<List<dynamic>> _fetchAssignments() async {
    final res = await supabase
        .from('notices')
        .select()
        .eq('type', 'assignment')
        .order('created_at', ascending: false);

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchAssignments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(child: Text('No assignments'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              DateTime? dueDate = item['due_date'] != null
                  ? DateTime.parse(item['due_date'])
                  : null;

              DateTime today = DateTime.now();

              bool expired = false;
              bool dueToday = false;

              if (dueDate != null) {
                final d1 =
                DateTime(today.year, today.month, today.day);
                final d2 =
                DateTime(dueDate.year, dueDate.month, dueDate.day);

                if (d2.isBefore(d1)) {
                  expired = true;
                } else if (d2.isAtSameMomentAs(d1)) {
                  dueToday = true;
                }
              }

              Color color;
              String status;

              if (expired) {
                color = Colors.red;
                status = 'Closed';
              } else if (dueToday) {
                color = Colors.orange;
                status = 'Due Today';
              } else {
                color = Colors.green;
                status = 'Active';
              }

              return Card(
                color: color.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(item['content'] ?? ''),

                      const SizedBox(height: 8),

                      if (dueDate != null)
                        Text(
                          'Due: ${dueDate.toString().split(' ')[0]}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style:
                              const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: expired
                              ? null
                              : () async {
                            try {
                              // 🔹 1. Pick file
                              final result =
                              await FilePicker.platform.pickFiles(
                                withData: true,
                              );

                              if (result == null) return;

                              final fileBytes =
                              result.files.single.bytes!;
                              final fileName =
                                  result.files.single.name;

                              // 🔹 2. Create assignment record
                              await db.createAssignment(
                                item['title'],
                                item['content'] ?? '',
                                dueDate ?? DateTime.now(),
                              );

                              // 🔹 3. Get latest assignment id
                              final assignments =
                              await db.getAssignments();
                              final assignmentId =
                              assignments.first['id'];

                              // 🔹 4. Submit assignment
                              await db.submitAssignment(
                                assignmentId,
                                fileBytes,
                                fileName,
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Assignment submitted successfully'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content:
                                  Text('Submit failed: $e'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            expired ? Colors.grey : Colors.green,
                          ),
                          child: Text(
                            expired
                                ? 'Submission Closed'
                                : 'Submit Assignment',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}