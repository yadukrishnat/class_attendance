import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String rollNumber;
  final bool isCurrent;
  final bool isAbsent;

  const StudentCard({
    required this.name,
    required this.rollNumber,
    this.isCurrent = false,
    this.isAbsent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrent
          ? Colors.blue.withOpacity(0.2)
          : (isAbsent ? Colors.red.withOpacity(0.2) : Colors.white),
      elevation: isCurrent ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAbsent ? Colors.red : Colors.green,
          child: Icon(
            isAbsent ? Icons.close : Icons.check,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(rollNumber),
      ),
    );
  }
}
