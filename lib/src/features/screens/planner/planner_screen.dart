import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/planner_controller.dart';
import 'widgets/actions_section.dart';
import 'widgets/input_section.dart';
import 'widgets/recent_scetions.dart';
import 'widgets/recommendation_section.dart';



class AIStudyPlannerScreen extends StatelessWidget {
  final AIStudyPlannerController controller = Get.put(AIStudyPlannerController());

  AIStudyPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              
              // Study Input Section
              StudyInputSection(),
              const SizedBox(height: 24),
              
              // AI Recommendations (only show when available)
              if (controller.showRecommendations.value)
                AIRecommendationsSection(),
              
              // Planning Actions (only show when recommendations are available)
              if (controller.showRecommendations.value) ...[
                const SizedBox(height: 24),
                PlanningActionsSection(),
              ],
              
              const SizedBox(height: 32),
              
              // Recent Sessions
              RecentSessionsSection(),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.psychology,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Study Planner',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    'Get personalized study recommendations',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}