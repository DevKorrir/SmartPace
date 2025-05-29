import 'package:flutter/material.dart';

class StudySessionModel {
  final String id;
  final String title;
  final String subject;
  final String startTime;
  final String endTime;
  final Color color;
  final String type;

  StudySessionModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.type,
  });
}