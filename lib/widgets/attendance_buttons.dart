import 'package:flutter/material.dart';

class AttendanceButtons extends StatelessWidget {
  final VoidCallback onPresent;
  final VoidCallback onAbsent;

  const AttendanceButtons({
    required this.onPresent,
    required this.onAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPresent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Present', style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onAbsent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Absent', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
