import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/study_session.dart';

class HomeController extends GetxController {
  var currentStudySession = ''.obs;
  var todayStudyTime = 0.obs; // in minutes
  var weeklyGoal = 20.obs; // hours
  var completedSessions = 3.obs;
  var totalSessions = 6.obs;
  var userName = 'Juma'.obs;

  // Mock data for upcoming sessions
  var upcomingSessions = <StudySession>[
    StudySession(
      title: 'Mathematics - Calculus',
      time: '2:00 PM - 3:30 PM',
      subject: 'Mathematics',
      color: Colors.blue,
      icon: Icons.calculate,
    ),
    StudySession(
      title: 'Random Forest Algorithm',
      time: '4:00 PM - 5:00 PM',
      subject: 'Machine Learning',
      color: Colors.purple,
      icon: Icons.data_exploration,
    ),
    StudySession(
      title: 'Data Structures - Algorithms',
      time: '7:00 PM - 8:30 PM',
      subject: 'BDS',
      color: Colors.green,
      icon: Icons.code,
    ),
  ].obs;

  double get weeklyProgress => todayStudyTime.value / (weeklyGoal.value * 60);
  double get dailyProgress => completedSessions.value / totalSessions.value;

  void startQuickSession() {
    // Quick session logic
    Get.snackbar(
      'Quick Session Started',
      'Your 25-minute focus session has begun!',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      snackPosition: SnackPosition.TOP,
    );
  }
}

