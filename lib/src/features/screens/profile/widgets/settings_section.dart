import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile-controller.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            'Notifications',
            'Receive study reminders',
            Icons.notifications,
            Obx(() => Switch(
              value: controller.notificationsEnabled.value,
              onChanged: controller.toggleNotifications,
            )),
          ),
          _buildSettingsTile(
            'Privacy',
            'Manage your data and privacy',
            Icons.privacy_tip,
            const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: controller.showPrivacySettings,
          ),
          _buildSettingsTile(
            'Help & Support',
            'Get help and contact support',
            Icons.help,
            const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: controller.showHelpAndSupport,
          ),
          _buildSettingsTile(
            'About',
            'App version and information',
            Icons.info,
            const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showAboutDialog(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSettingsTile(String title, String subtitle, IconData icon, Widget trailing, {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.grey[600]),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      trailing: trailing,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
 void _showAboutDialog() {
    Get.dialog(
      AboutDialog(
        applicationName: 'SmartPace',
        applicationVersion: '1.0.0',
        applicationIcon: const Icon(Icons.school, size: 32),
        children: const [
          Text('A simple app to plan and track your study sessions, form or join study groups, chat with study mates and improve your learning habits.'),
        ],
      ),
    );
  }
}
