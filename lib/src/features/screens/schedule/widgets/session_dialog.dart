 import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/planner_controller.dart';
import '../models/study_session_model.dart';

 void showSessionDialog(BuildContext context, StudySessionModel? existingSession) {
        final PlannerController controller = Get.put(PlannerController());

    final titleController = TextEditingController(text: existingSession?.title ?? '');
    final subjectController = TextEditingController(text: existingSession?.subject ?? '');
    final startTimeController = TextEditingController(text: existingSession?.startTime ?? '');
    final endTimeController = TextEditingController(text: existingSession?.endTime ?? '');

    final colors = [Colors.blue, Colors.purple, Colors.green, Colors.orange, Colors.red, Colors.teal];

    String selectedSubject = existingSession?.subject ?? "";
    Color selectedColor = existingSession?.color ?? colors.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(existingSession == null ? 'Add Study Session' : 'Edit Study Session'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Session Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Start Time',
                          hintText: '09:00',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: endTimeController,
                        decoration: InputDecoration(
                          labelText: 'End Time',
                          hintText: '10:30',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Color selection
                Row(
                  children: [
                    const Text('Color: '),
                    const SizedBox(width: 8),
                    ...colors.map((color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selectedColor == color
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    )).toList(),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final session = StudySessionModel(
                    id: existingSession?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    subject: selectedSubject,
                    startTime: startTimeController.text,
                    endTime: endTimeController.text,
                    color: selectedColor,
                    type: 'Study Session',
                  );

                  if (existingSession == null) {
                    controller.addSession(session);
                  } else {
                    controller.editSession(session);
                  }

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(existingSession == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }