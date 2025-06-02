import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
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
