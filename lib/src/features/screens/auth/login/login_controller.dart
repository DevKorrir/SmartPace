import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routing/navigation/navigation.dart';
import '../../../authentication/auth_repository/auth_repository.dart';
import '../../../authentication/auth_repository/exceptions/sign_up_email_and_password_failure.dart';
import '../../../forgot_password/forgot_password_options/forgot_password_model_bottom_sheet.dart';
import '../signup/sign_up.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;

  var emailError = ''.obs;
  var passwordError = ''.obs;

  bool get isFormValid =>
      emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          emailError.value.isEmpty &&
          passwordError.value.isEmpty;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validate email
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }

  // Validate password
  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }

  // Handle login with Firebase
  Future<void> handleLogin() async {

    // validate form first
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    if (!isFormValid) {
      _showErrorSnackbar(
        'Invalid Input',
        'Please enter valid email and password',
      );
      return;
    }

    isLoading.value = true;

    try {

      bool isEmailVerified = await AuthRepository.instance.checkEmailVerificationStatus(
        emailController.text.trim(),
        passwordController.text.trim(),
      );


      // Success - Show success message
      _showSuccessSnackbar(
        'Welcome Back!',
        'Login successful',
      );

      // Clear form data
      _clearForm();

     // Navigate to main app
      Get.offAll(() => MainNavigation());

    } on SignUpWithEmailAndPasswordFailure catch (e) {
      // Handle specific authentication exceptions
      _handleAuthException(e);

    } catch (e) {
      // Handle unexpected errors
      print('Unexpected login error: $e');
      _showErrorSnackbar(
        'Login Failed',
        'An unexpected error occurred. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }


  // Handle specific authentication exceptions
  void _handleAuthException(SignUpWithEmailAndPasswordFailure exception) {
    if (exception.message.contains('email-not-verified')) {
      _showEmailVerificationDialog();
    } else if (exception.message.contains('user-not-found')) {
      _showErrorSnackbar(
        'Account Not Found',
        'No account found with this email. Please sign up first.',
      );
    } else if (exception.message.contains('wrong-password')) {
      _showErrorSnackbar(
        'Incorrect Password',
        'The password you entered is incorrect. Please try again.',
      );
    } else if (exception.message.contains('user-disabled')) {
      _showErrorSnackbar(
        'Account Disabled',
        'This account has been disabled. Please contact support.',
      );
    } else if (exception.message.contains('too-many-requests')) {
      _showErrorSnackbar(
        'Too Many Attempts',
        'Too many failed login attempts. Please try again later.',
      );
    } else {
      _showErrorSnackbar('Login Failed', exception.message);
    }
  }

  // Show email verification dialog
  void _showEmailVerificationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Email Not Verified',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Please verify your email address before signing in. Check your inbox for the verification email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _resendVerificationEmail();
            },
            child: const Text(
              'Resend Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }



  // Resend verification email
  Future<void> _resendVerificationEmail() async {
    try {
      isLoading.value = true;

      // First try to create a temporary account to resend verification
      // This is a workaround since the user isn't signed in
      await AuthRepository.instance.loginUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      // If we get here, the user might be signed in, try to resend
      await AuthRepository.instance.resendEmailVerification();

      _showSuccessSnackbar(
        'Email Sent',
        'Verification email has been sent successfully.',
      );

    } catch (e) {
      _showErrorSnackbar(
        'Failed to Send',
        'Could not send verification email. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));

      Get.offAll(() => MainNavigation());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google Sign In failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Handle forgot password
  Future<void> handleForgotPassword() async {
    if (emailController.text.isEmpty) {
      _showErrorSnackbar(
        'Email Required',
        'Please enter your email address first.',
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      _showErrorSnackbar(
        'Invalid Email',
        'Please enter a valid email address.',
      );
      return;
    }

    try {
      isLoading.value = true;

      // You'll need to add this method to your AuthRepository
      await AuthRepository.instance.sendPasswordResetEmail(emailController.text.trim());

      _showSuccessSnackbar(
        'Reset Email Sent',
        'Password reset instructions have been sent to your email.',
      );

    } catch (e) {
      _showErrorSnackbar(
        'Reset Failed',
        'Could not send password reset email. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to forgot password
  void navigateToForgotPassword() {
    ForgotPasswordScreen.buildShowModalBottomSheet(Get.context!);
  }

  // Navigate to sign up
  void navigateToSignUp() {
    Get.to(() => const SignUp());
  }

  // Clear form data
  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    emailError.value = '';
    passwordError.value = '';
    isPasswordVisible.value = false;
  }

  // Show success snackbar
  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  // Show error snackbar
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}