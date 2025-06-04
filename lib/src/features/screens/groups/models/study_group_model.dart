import 'package:flutter/material.dart';

class StudyGroupModel {
  final String id;
  final String name;
  final String subject;
  final String lastMessage;
  final String time;
  final int memberCount;
  final int unreadCount;
  final Color color;
  final bool isActive;

  StudyGroupModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.lastMessage,
    required this.time,
    required this.memberCount,
    required this.unreadCount,
    required this.color,
    required this.isActive,
  });

  StudyGroupModel copyWith({
    String? id,
    String? name,
    String? subject,
    String? lastMessage,
    String? time,
    int? memberCount,
    int? unreadCount,
    Color? color,
    bool? isActive,
  }) {
    return StudyGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      memberCount: memberCount ?? this.memberCount,
      unreadCount: unreadCount ?? this.unreadCount,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }
}