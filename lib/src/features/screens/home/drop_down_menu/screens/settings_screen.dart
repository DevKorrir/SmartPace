import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionHeader('Account'),
            _buildSettingsTile(
              icon: Icons.account_circle,
              title: 'Profile Settings',
              subtitle: 'Edit your profile information',
              onTap: () => Get.toNamed('/profile'),
            ),
            _buildSettingsTile(
              icon: Icons.security,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              onTap: () => Get.toNamed('/privacy'),
            ),
            
            const SizedBox(height: 24),
            
            // App Settings Section
            _buildSectionHeader('App Settings'),
            Obx(() => _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive notifications for updates',
              value: settingsController.notificationsEnabled.value,
              onChanged: (value) => settingsController.toggleNotifications(value),
            )),
            Obx(() => _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              value: settingsController.darkModeEnabled.value,
              onChanged: (value) => settingsController.toggleDarkMode(value),
            )),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Choose your preferred language',
              trailing: Obx(() => Text(
                settingsController.selectedLanguage.value,
                style: TextStyle(color: Colors.grey[600]),
              )),
              onTap: () => _showLanguageDialog(),
            ),
            
            const SizedBox(height: 24),
            
            // Study Settings Section
            _buildSectionHeader('Study Settings'),
            _buildSettingsTile(
              icon: Icons.schedule,
              title: 'Study Reminders',
              subtitle: 'Set up study reminder times',
              onTap: () => Get.toNamed('/study-reminders'),
            ),
            _buildSettingsTile(
              icon: Icons.folder,
              title: 'Data & Storage',
              subtitle: 'Manage your study data',
              onTap: () => Get.toNamed('/data-storage'),
            ),
            
            const SizedBox(height: 24),
            
            // Support Section
            _buildSectionHeader('Support'),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and support',
              onTap: () => Get.toNamed('/help'),
            ),
            _buildSettingsTile(
              icon: Icons.feedback,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              onTap: () => _showFeedbackDialog(),
            ),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About SmartPace',
              subtitle: 'Version info and credits',
              onTap: () => Get.toNamed('/about'),
            ),
            
            const SizedBox(height: 32),
            
            // Logout Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    
    Get.dialog(
      AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: settingsController.selectedLanguage.value,
              onChanged: (value) {
                if (value != null) {
                  settingsController.setLanguage(value);
                  Get.back();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Send Feedback'),
        content: TextField(
          controller: feedbackController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle feedback submission
              Get.back();
              Get.snackbar(
                'Thank You!',
                'Your feedback has been sent successfully.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle logout
              Get.back();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}