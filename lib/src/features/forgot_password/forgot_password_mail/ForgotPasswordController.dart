import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication/auth_repository/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final emailController = TextEditingController();
  
  var isLoading = false.obs;
  var emailError = ''.obs;

  bool get isFormValid => 
      emailController.text.isNotEmpty && 
      emailError.value.isEmpty;

  // Validate email
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email address';
    } else {
      emailError.value = '';
    }
  }

  // Handle password reset
  Future<void> handlePasswordReset() async {
    // Validate email first
    validateEmail(emailController.text);
    
    if (!isFormValid) {
      _showErrorSnackbar(
        'Invalid Email',
        emailError.value.isNotEmpty ? emailError.value : 'Please enter a valid email',
      );
      return;
    }

    isLoading.value = true;

    try {
      // Use your existing auth repository method
      await AuthRepository.instance.sendPasswordResetEmail(emailController.text.trim());
      
      // Show success dialog with instructions
      _showSuccessDialog();
      
    } catch (e) {
      // Error handling is already done in your auth method via snackbars
      print('Password reset error: $e');
      
      // Only show additional error if the auth method didn't handle it properly
      if (!e.toString().contains('No account found') && 
          !e.toString().contains('Invalid email') &&
          !e.toString().contains('Too many requests')) {
        _showErrorSnackbar(
          'Reset Failed',
          'Unable to send reset email. Please try again.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Show success dialog with instructions
  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Email Sent!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Password reset instructions sent to:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      emailController.text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Please check:'),
            const Text('• Your inbox'),
            const Text('• Spam/Junk folder'),
            const Text('• Promotions tab'),
            const SizedBox(height: 16),
            const Text(
              'Click the link in the email to reset your password.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to previous screen
            },
            child: const Text('Back to Login'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await handlePasswordReset(); // Resend email
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Resend Email'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Show error snackbar (matching your LoginController style)
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.red),
    );
  }

  // Clear form data
  void clearForm() {
    emailController.clear();
    emailError.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}