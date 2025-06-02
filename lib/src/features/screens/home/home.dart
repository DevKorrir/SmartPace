import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/home/widgets/build_header.dart';
import 'package:smart_pace/src/features/screens/home/widgets/progress_cards.dart';
import 'package:smart_pace/src/features/screens/home/widgets/quick_actions.dart';
import 'package:smart_pace/src/features/screens/home/widgets/study_streak.dart';
import 'package:smart_pace/src/features/screens/home/widgets/upcoming_sessions.dart';

import 'controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(),
              const SizedBox(height: 24),
              ProgressCards(),
              const SizedBox(height: 24),
              QuickActions(),
              const SizedBox(height: 24),
              UpcomingSessions(),
              const SizedBox(height: 24),
              StudyStreak(),
            ],
          ),
        ),
      ),
    );
  }
}
