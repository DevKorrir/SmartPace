// controllers/account_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  // Observable variables for user data
  var userName = 'Jude'.obs;
  var userEmail = 'example@students.must.ac.ke'.obs;
  var userPhone = ''.obs;
  var userInstitution = ''.obs;
  var studyLevel = ''.obs;
  var profileImageUrl = ''.obs;
  var isLoading = false.obs;

  // User preferences keys
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';
  static const String _userInstitutionKey = 'user_institution';
  static const String _studyLevelKey = 'study_level';
  static const String _profileImageUrlKey = 'profile_image_url';

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Load user data from shared preferences
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      
      userName.value = prefs.getString(_userNameKey) ?? 'Jude';
      userEmail.value = prefs.getString(_userEmailKey) ?? 'example@students.ac.ke';
      userPhone.value = prefs.getString(_userPhoneKey) ?? '';
      userInstitution.value = prefs.getString(_userInstitutionKey) ?? '';
      studyLevel.value = prefs.getString(_studyLevelKey) ?? '';
      profileImageUrl.value = prefs.getString(_profileImageUrlKey) ?? '';
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error loading user data: $e');
    }
  }

  // Save user data to shared preferences
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_userNameKey, userName.value);
      await prefs.setString(_userEmailKey, userEmail.value);
      await prefs.setString(_userPhoneKey, userPhone.value);
      await prefs.setString(_userInstitutionKey, userInstitution.value);
      await prefs.setString(_studyLevelKey, studyLevel.value);
      await prefs.setString(_profileImageUrlKey, profileImageUrl.value);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Update a specific field
  void updateField(String field, String value) {
    switch (field) {
      case 'name':
        userName.value = value;
        break;
      case 'email':
        userEmail.value = value;
        break;
      case 'phone':
        userPhone.value = value;
        break;
      case 'institution':
        userInstitution.value = value;
        break;
      case 'studyLevel':
        studyLevel.value = value;
        break;
    }
    
    _saveUserData();
    
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Update profile image
  void updateProfileImage(String imageUrl) {
    profileImageUrl.value = imageUrl;
    _saveUserData();
    
    Get.snackbar(
      'Success',
      'Profile picture updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Change password
  void changePassword(String currentPassword, String newPassword) {
    // In a real app, you would validate the current password with your backend
    // For now, we'll simulate the process
    
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all password fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Error',
        'New password must be at least 6 characters long',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Simulate API call
    _performPasswordChange(currentPassword, newPassword);
  }

  Future<void> _performPasswordChange(String currentPassword, String newPassword) async {
    try {
      isLoading.value = true;
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, make API call to change password
      // For demo purposes, we'll just show success
      
      isLoading.value = false;
      
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to change password. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Export user data
  void exportUserData() {
    try {
      // In a real app, you would generate and download a file
      // For demo purposes, we'll show the data in a dialog
      
      final userData = {
        'name': userName.value,
        'email': userEmail.value,
        'phone': userPhone.value,
        'institution': userInstitution.value,
        'studyLevel': studyLevel.value,
        'exportDate': DateTime.now().toIso8601String(),
      };

      Get.dialog(
        AlertDialog(
          title: const Text('Export Data'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Your account data:'),
                const SizedBox(height: 10),
                ...userData.entries.map((entry) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('${entry.key}: ${entry.value}'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // In a real app, trigger file download here
                Get.back();
                Get.snackbar(
                  'Export Complete',
                  'Your data has been exported successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const Text('Download'),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Delete account
  void deleteAccount(String password) {
    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password to confirm',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _performAccountDeletion(password);
  }

  Future<void> _performAccountDeletion(String password) async {
    try {
      isLoading.value = true;
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, make API call to delete account
      // Clear all local data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      isLoading.value = false;
      
      Get.snackbar(
        'Account Deleted',
        'Your account has been permanently deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to login/welcome screen
      Get.offAllNamed('/welcome');
      
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to delete account. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Update user profile with multiple fields
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? institution,
    String? studyLevel,
  }) {
    if (name != null) userName.value = name;
    if (email != null) userEmail.value = email;
    if (phone != null) userPhone.value = phone;
    if (institution != null) userInstitution.value = institution;
    if (studyLevel != null) studyLevel = studyLevel;
    
    _saveUserData();
    
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone number format
  bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-()]+$').hasMatch(phone);
  }
}