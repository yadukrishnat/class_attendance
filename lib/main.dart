import 'package:flutter/material.dart';
import 'screens/import_students_screen.dart';
import 'screens/attendance_screen.dart'; // <- must exist
import 'screens/absentees_screen.dart';  // <- must exist

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ImportStudentsScreen(),
        '/attendance': (context) => AttendanceScreen(),
        '/absentees': (context) => AbsenteesScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
