import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/study_session_model.dart';

class PlannerController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var currentWeekOffset = 0.obs;
  var selectedTimeSlot = ''.obs;
  var isAddingSession = false.obs;

  // Study session data structure
  var weekSessions = <DateTime, List<StudySessionModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfter = today.add(const Duration(days: 2));

    weekSessions.value = {
      today: [
        StudySessionModel(
          id: '1',
          title: 'Mathematics - Calculus',
          subject: 'Mathematics',
          startTime: '09:00',
          endTime: '10:30',
          color: Colors.blue,
          type: 'Lecture Review',
        ),
        StudySessionModel(
          id: '2',
          title: 'Random Forest Algorithm',
          subject: 'ML Algorithms',
          startTime: '14:00',
          endTime: '15:30',
          color: Colors.purple,
          type: 'Assignment',
        ),
      ],
      tomorrow: [
        StudySessionModel(
          id: '3',
          title: 'Computer Science - Algorithms',
          subject: 'CS',
          startTime: '10:00',
          endTime: '11:30',
          color: Colors.green,
          type: 'Study Session',
        ),
        StudySessionModel(
          id: '4',
          title: 'Agile Methodology',
          subject: 'Software Engineering',
          startTime: '16:00',
          endTime: '17:30',
          color: Colors.orange,
          type: 'Study session',
        ),
      ],
      dayAfter: [
        StudySessionModel(
          id: '5',
          title: 'SQL basics',
          subject: 'Database',
          startTime: '11:00',
          endTime: '12:30',
          color: Colors.red,
          type: 'Personal study',
        ),
      ],
    };
  }

  List<DateTime> get currentWeekDays {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final offsetWeekStart = weekStart.add(Duration(days: currentWeekOffset.value * 7));

    return List.generate(7, (index) =>
        offsetWeekStart.add(Duration(days: index))
    );
  }

  void navigateWeek(int direction) {
    currentWeekOffset.value += direction;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  List<StudySessionModel> getSessionsForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return weekSessions[dateKey] ?? [];
  }

  void addSession(StudySessionModel session) {
    final dateKey = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day);
    if (weekSessions[dateKey] == null) {
      weekSessions[dateKey] = [];
    }
    weekSessions[dateKey]!.add(session);
    weekSessions.refresh();
    isAddingSession.value = false;
  }

  void deleteSession(String sessionId) {
    weekSessions.forEach((date, sessions) {
      sessions.removeWhere((session) => session.id == sessionId);
    });
    weekSessions.refresh();
  }

  void editSession(StudySessionModel updatedSession) {
    weekSessions.forEach((date, sessions) {
      for (int i = 0; i < sessions.length; i++) {
        if (sessions[i].id == updatedSession.id) {
          sessions[i] = updatedSession;
          break;
        }
      }
    });
    weekSessions.refresh();
  }
}


