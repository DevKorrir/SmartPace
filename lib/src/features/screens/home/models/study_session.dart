import 'package:flutter/material.dart';
class StudySession {
  final String title;
  final String time;
  final String subject;
  final Color color;
  final IconData icon;

  StudySession({
    required this.title,
    required this.time,
    required this.subject,
    required this.color,
    required this.icon,
  });
}
