import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/planner_controller.dart';

import 'widgets/header.dart';
import 'widgets/session_dialog.dart';
import 'widgets/week_selector.dart';
import 'widgets/weekly_view.dart';

class PlannerScreen extends StatelessWidget {
  final PlannerController controller = Get.put(PlannerController());

  PlannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            SchedulleHeader(),
            WeekSelector(),
            Expanded(child: WeeklyView()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddSessionDialog(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Session',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void showAddSessionDialog(BuildContext context) {
    showSessionDialog(context, null);
  }
}
