import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/planner_controller.dart';
import '../models/days.dart';

class TimeHeader extends StatelessWidget {
  const TimeHeader({super.key});

  @override
  Widget build(BuildContext context) {
            final PlannerController controller = Get.put(PlannerController());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Obx(() {
        final selectedDay = getDayName(controller.selectedDate.value.weekday);
        final dateStr = getFormattedDate(controller.selectedDate.value);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedDay,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Obx(() {
              final sessionsCount = controller.getSessionsForDate(controller.selectedDate.value).length;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$sessionsCount Sessions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}