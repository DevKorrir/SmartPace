import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for managing profile state
class ProfileController extends GetxController {
  // User data - reactive variables
  final userName = "Derick Juma".obs;
  final userEmail = "derekjude254@gmail.com".obs;
  final userYear = "Year 2".obs;
  final profileImageUrl = "".obs;

  // Study statistics
  final totalSessions = 45.obs;
  final totalHours = 120.obs;
  final currentStreak = 7.obs;

  // Settings
  final notificationsEnabled = true.obs;
  final darkModeEnabled = false.obs;
  final selectedTheme = "System".obs;

  // Methods for user actions
  void updateProfile(String name, String email, String year) {
    userName.value = name;
    userEmail.value = email;
    userYear.value = year;
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void toggleDarkMode(bool value) {
    darkModeEnabled.value = value;
  }

  void exportData() {
    Get.snackbar(
      'Success',
      'Data exported successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void backupData() {
    Get.snackbar(
      'Success',
      'Data backed up to cloud!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void shareProgress() {
    Get.snackbar(
      'Success',
      'Progress shared!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void showPrivacySettings() {
    Get.snackbar(
      'Info',
      'Privacy settings opened',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showHelpAndSupport() {
    Get.snackbar(
      'Info',
      'Help & Support opened',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signOut() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Signed out successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  String getInitials(String name) {
    return name.split(' ').map((word) => word[0]).take(2).join().toUpperCase();
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Obx(() => IconButton(
            icon: Icon(controller.darkModeEnabled.value 
                ? Icons.light_mode 
                : Icons.dark_mode),
            onPressed: () => controller.toggleDarkMode(!controller.darkModeEnabled.value),
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(controller),
            const SizedBox(height: 24),

            // Study Statistics
            _buildStudyStats(controller),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(controller),
            const SizedBox(height: 24),

            // Settings Options
            _buildSettingsSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
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
        children: [
          // Profile Picture
          Stack(
            children: [
              Obx(() => CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[100],
                child: controller.profileImageUrl.value.isEmpty
                    ? Text(
                  controller.getInitials(controller.userName.value),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )
                    : ClipOval(
                  child: Image.network(
                    controller.profileImageUrl.value,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User Info
          Obx(() => Text(
            controller.userName.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          )),
          const SizedBox(height: 4),
          Obx(() => Text(
            controller.userEmail.value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          )),
          const SizedBox(height: 4),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              controller.userYear.value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
          const SizedBox(height: 16),

          // Edit Profile Button
          ElevatedButton.icon(
            onPressed: () => _showEditProfileDialog(controller),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyStats(ProfileController controller) {
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
            'Study Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildStatCard(
                  'Total Sessions',
                  controller.totalSessions.value.toString(),
                  Icons.book,
                  Colors.blue,
                )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() => _buildStatCard(
                  'Study Hours',
                  '${controller.totalHours.value}h',
                  Icons.access_time,
                  Colors.green,
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildStatCard(
                  'Current Streak',
                  '${controller.currentStreak.value} days',
                  Icons.local_fire_department,
                  Colors.orange,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ProfileController controller) {
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
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Export Data',
                  Icons.download,
                  Colors.blue,
                  controller.exportData,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Backup',
                  Icons.cloud_upload,
                  Colors.green,
                  controller.backupData,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Share',
                  Icons.share,
                  Colors.orange,
                  controller.shareProgress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(ProfileController controller) {
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

  void _showEditProfileDialog(ProfileController controller) {
    final nameController = TextEditingController(text: controller.userName.value);
    final emailController = TextEditingController(text: controller.userEmail.value);
    final gradeController = TextEditingController(text: controller.userYear.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateProfile(
                nameController.text,
                emailController.text,
                gradeController.text,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
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