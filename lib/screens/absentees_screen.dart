import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class AbsenteesScreen extends StatefulWidget {
  @override
  _AbsenteesScreenState createState() => _AbsenteesScreenState();
}

class _AbsenteesScreenState extends State<AbsenteesScreen> {
  List<Map<String, dynamic>> absentees = [];
  String? batchId;
  bool _isLoaded = false; // ensures fetch happens only once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      batchId = ModalRoute.of(context)!.settings.arguments as String?;
      if (batchId != null) _fetchAbsentees(batchId!);
      _isLoaded = true;
    }
  }

  Future<void> _fetchAbsentees(String batchId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('''
      SELECT s.student_name, s.roll_number
      FROM Absence a
      INNER JOIN Students s ON s.id = a.student_id
      WHERE a.batch_id = ?
      ORDER BY s.student_name
    ''', [batchId]);

    setState(() {
      absentees.clear(); // clear old data
      absentees.addAll(result); // add new batch data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absentees List'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: absentees.isEmpty
          ? Center(
        child: Text(
          'No absentees recorded',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
      )
          : Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: absentees.length,
          itemBuilder: (context, index) {
            final student = absentees[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.cancel, color: Colors.white),
                ),
                title: Text(
                  student['student_name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  student['roll_number'],
                  style: TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
