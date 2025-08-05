import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/planner_controller.dart';

class PlanningActionsSection extends StatelessWidget {
  PlanningActionsSection({super.key});

  final AIStudyPlannerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Steps',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Choose how you\'d like to proceed with your study plan:',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          // Primary Action - Plan & Set Reminder
          _buildActionButton(
            title: 'Plan & Set Reminder',
            subtitle: 'Schedule this session and get notifications',
            icon: Icons.schedule,
            color: Colors.blue,
            isPrimary: true,
            onTap: controller.proceedToPlanning,
          ),
          const SizedBox(height: 12),

          // Secondary Actions Row
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  title: 'Skip to Manual',
                  subtitle: 'Create your own plan',
                  icon: Icons.edit_calendar,
                  color: Colors.grey,
                  isPrimary: false,
                  onTap: controller.skipToManualPlanning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  title: 'Try Again',
                  subtitle: 'Get new recommendations',
                  icon: Icons.refresh,
                  color: Colors.orange,
                  isPrimary: false,
                  onTap: () {
                    controller.clearForm();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isPrimary ? 20 : 16),
        decoration: BoxDecoration(
          color: isPrimary ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary ? color : Colors.grey.shade200,
            width: isPrimary ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: isPrimary ? 24 : 20),
                ),
                if (isPrimary) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (!isPrimary) ...[
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void proceedToPlanning() {
    // Logic to proceed with planning and setting reminders
    Get.snackbar(
      'Planning',
      'Proceeding to plan your study session',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade800,
    );
  }
}
