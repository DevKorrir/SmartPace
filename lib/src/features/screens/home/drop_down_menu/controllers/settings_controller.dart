import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Observable variables
  var notificationsEnabled = true.obs;
  var darkModeEnabled = false.obs;
  var selectedLanguage = 'English'.obs;
  var studyRemindersEnabled = true.obs;
  
  // User preferences keys
  static const String _notificationsKey = 'notifications_enabled';
  static const String _darkModeKey = 'dark_mode_enabled';
  static const String _languageKey = 'selected_language';
  static const String _studyRemindersKey = 'study_reminders_enabled';

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  // Load settings from shared preferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      notificationsEnabled.value = prefs.getBool(_notificationsKey) ?? true;
      darkModeEnabled.value = prefs.getBool(_darkModeKey) ?? false;
      selectedLanguage.value = prefs.getString(_languageKey) ?? 'English';
      studyRemindersEnabled.value = prefs.getBool(_studyRemindersKey) ?? true;
      
      // Apply theme based on saved preference
      _applyTheme();
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  // Save settings to shared preferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_notificationsKey, notificationsEnabled.value);
      await prefs.setBool(_darkModeKey, darkModeEnabled.value);
      await prefs.setString(_languageKey, selectedLanguage.value);
      await prefs.setBool(_studyRemindersKey, studyRemindersEnabled.value);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    _saveSettings();
    
    // Show feedback to user
    Get.snackbar(
      'Notifications',
      value ? 'Push notifications enabled' : 'Push notifications disabled',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Toggle dark mode
  void toggleDarkMode(bool value) {
    darkModeEnabled.value = value;
    _saveSettings();
    _applyTheme();
    
    Get.snackbar(
      'Theme',
      value ? 'Dark mode enabled' : 'Light mode enabled',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Apply theme based on dark mode setting
  void _applyTheme() {
    Get.changeThemeMode(
      darkModeEnabled.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  // Set language
  void setLanguage(String language) {
    selectedLanguage.value = language;
    _saveSettings();
    
    // Here you would typically update the app's locale
    // For example: Get.updateLocale(Locale('en', 'US'));
    
    Get.snackbar(
      'Language',
      'Language changed to $language',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Toggle study reminders
  void toggleStudyReminders(bool value) {
    studyRemindersEnabled.value = value;
    _saveSettings();
    
    Get.snackbar(
      'Study Reminders',
      value ? 'Study reminders enabled' : 'Study reminders disabled',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Clear all data (for data management)
  void clearAllData() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your study data, notes, and progress. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear all app data here
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              Get.back();
              Get.snackbar(
                'Data Cleared',
                'All data has been successfully cleared',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Export user data
  void exportData() {
    // Implement data export functionality
    Get.snackbar(
      'Export Data',
      'Data export feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Reset settings to default
  void resetToDefaults() {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('This will reset all settings to their default values.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notificationsEnabled.value = true;
              darkModeEnabled.value = false;
              selectedLanguage.value = 'English';
              studyRemindersEnabled.value = true;
              
              _saveSettings();
              _applyTheme();
              
              Get.back();
              Get.snackbar(
                'Settings Reset',
                'All settings have been reset to defaults',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}