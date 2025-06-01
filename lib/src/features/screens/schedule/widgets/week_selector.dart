import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/planner_controller.dart';
import '../models/days.dart';
import 'day_selector.dart';

class WeekSelector extends StatelessWidget {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context) {
            final PlannerController controller = Get.put(PlannerController());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        final weekDays = controller.currentWeekDays;
        final monthYear = getMonthYear(weekDays.first, weekDays.last);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => controller.navigateWeek(-1),
                  icon: const Icon(Icons.chevron_left, size: 28),
                  color: Colors.black54,
                ),
                Text(
                  monthYear,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.navigateWeek(1),
                  icon: const Icon(Icons.chevron_right, size: 28),
                  color: Colors.black54,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((date) => buildDaySelector(date)).toList(),
            ),
          ],
        );
      }),
    );
  }
}