import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/schedule/controller/planner_controller.dart';

import '../models/days.dart';

Widget buildDaySelector(DateTime date) {
  final PlannerController controller = Get.put(PlannerController());

  return Obx(() {
    final isSelected = isSameDay(date, controller.selectedDate.value);
    final isToday = isSameDay(date, DateTime.now());
    final sessionsCount = controller.getSessionsForDate(date).length;

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: Container(
        width: 45,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border:
              isToday && !isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getDayName(date.weekday),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            if (sessionsCount > 0)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  });
}


/*void showAddSessionDialog(BuildContext context) {
    showSessionDialog(context, null);
  } */

  
