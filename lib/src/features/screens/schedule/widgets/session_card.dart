import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/planner_controller.dart';
import '../models/study_session_model.dart';

Widget sessionCard(StudySessionModel session) {
  final PlannerController controller = Get.put(PlannerController());

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: session.color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: session.color.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: session.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      session.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 16),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        controller.deleteSession(session.id);
                      } else if (value == 'edit') {
                        // _showEditSessionDialog(context, session);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${session.startTime} - ${session.endTime}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: session.color,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: session.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.subject,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: session.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    session.type,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
