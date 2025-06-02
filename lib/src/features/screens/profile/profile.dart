import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/widgets/quick_actions.dart';
import 'controllers/profile-controller.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_section.dart';
import 'widgets/study_stats.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.darkModeEnabled.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed:
                  () => controller.toggleDarkMode(
                    !controller.darkModeEnabled.value,
                  ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            ProfileHeader(),
            const SizedBox(height: 24),

            // Study Statistics
            StudyStats(),
            const SizedBox(height: 24),

            // Quick Actions
            QuickActions(),
            const SizedBox(height: 24),

            // Settings Options
            SettingsSection(),
          ],
        ),
      ),
    );
  }
}
