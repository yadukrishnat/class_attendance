import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> students = [];
  int currentIndex = 0;
  Set<int> absentees = {};
  String? batchId;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      batchId = ModalRoute.of(context)!.settings.arguments as String?;
      if (batchId != null) _loadBatchData(batchId!);
      _isLoaded = true;
    }
  }




  Future<void> _loadBatchData(String batchId) async {
    await _clearOldAttendance(batchId);
    await _fetchStudents(batchId);
  }

  Future<void> _clearOldAttendance(String batchId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'Absence',
      where: 'student_id IN (SELECT id FROM Students WHERE batch_id = ?)',
      whereArgs: [batchId],
    );
    absentees.clear();
  }

  Future<void> _fetchStudents(String batchId) async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query(
      'Students',
      where: 'batch_id = ?',
      whereArgs: [batchId],
    );
    setState(() {
      students.clear();
      students.addAll(data);
      currentIndex = 0;
    });
  }

  void _mark(bool absent) async {
    if (absent) {
      final db = await DatabaseHelper.instance.database;
      await db.insert('Absence', {
        'student_id': students[currentIndex]['id'],
        'batch_id': batchId,
        'date_time': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });
      absentees.add(students[currentIndex]['id']);
    }

    if (currentIndex < students.length - 1) {
      setState(() => currentIndex++);
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/absentees',
        arguments: batchId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take Attendance'), centerTitle: true),
      body: students.isEmpty
          ? Center(child: Text('No students found.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                bool isAbsent = absentees.contains(students[index]['id']);
                bool isCurrent = index == currentIndex;

                return Card(
                  color: isCurrent
                      ? Colors.blue.withOpacity(0.9)
                      : (isAbsent ? Colors.red.withOpacity(0.2) : Colors.white),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isAbsent ? Colors.red : Colors.green,
                      child: Icon(isAbsent ? Icons.close : Icons.check,
                          color: Colors.white),
                    ),
                    title: Text(students[index]['student_name']),
                    subtitle: Text(students[index]['roll_number']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _mark(false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Present'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _mark(true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: Text('Absent'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
