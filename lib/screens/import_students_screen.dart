import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../db/database_helper.dart';

class ImportStudentsScreen extends StatefulWidget {
  @override
  _ImportStudentsScreenState createState() => _ImportStudentsScreenState();
}

class _ImportStudentsScreenState extends State<ImportStudentsScreen> {
  bool loading = false;
  final uuid = Uuid();

  Future<void> _importExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => loading = true);

      final path = result.files.single.path!;
      final bytes = File(path).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final db = await DatabaseHelper.instance.database;

      // generate a new batch ID for this import
      final currentBatchId = uuid.v4();

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows.skip(1)) {
          await db.insert('Students', {
            'student_name': row[0]?.value.toString() ?? '',
            'roll_number': row[1]?.value.toString() ?? '',
            'course_name': row[2]?.value.toString() ?? '',
            'batch_id': currentBatchId,
          });
        }
      }

      setState(() => loading = false);

      Navigator.pushNamed(
        context,
        '/attendance',
        arguments: currentBatchId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Students'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: loading
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.blueAccent),
            SizedBox(height: 16),
            Text('Importing Students...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        )
            : ElevatedButton.icon(
          onPressed: _importExcel,
          icon: Icon(Icons.upload_file),
          label: Text('Select Excel File'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ),
    );
  }
}
