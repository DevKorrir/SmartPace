import 'package:firebase_auth/firebase_auth.dart';
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

      // Check email verification status - this will throw exception if not verified
      await AuthRepository.instance.loginUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      // If we reach here, user is verified and signed in
      print('=== LOGIN SUCCESSFUL - USER IS VERIFIED ===');


      // Optionally, get user data from Firestore to confirm
      final userData = await AuthRepository.instance.getUserData();
      if (userData != null) {
        print('User data from Firestore: ${userData['firstName']} (${userData['email']})');

        // You can use this data to personalize the welcome message
        String firstName = userData['fullName'] ?? 'User';
        _showSuccessSnackbar(
          'Welcome Back, $firstName!',
          'Login successful',
        );
      } else {
        // Success - Show success message
        _showSuccessSnackbar(
          'Welcome Back!',
          'Login successful',
        );
      }

      // Clear form data
      _clearForm();

     // Navigate to main app
      Get.offAll(() => MainNavigation());

    } on SignUpWithEmailAndPasswordFailure catch (e) {
      // Handle email not verified specifically
      if (e.message.contains('email-not-verified') ||
          e.message.contains('verify your email')) {
        _showEmailNotVerifiedDialog();
      } else {
        // Handle other authentication exceptions
        _handleAuthException(e);
      }
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

  // Handle Google Sign In (Updated to save to Firestore)
  Future<void> handleGoogleSignIn() async {
    try {
      isLoading.value = true;

      print('=== STARTING GOOGLE SIGN IN FROM CONTROLLER ===');

      // This will handle the entire Google Sign In flow:
      // 1. Google authentication
      // 2. Phone number collection
      // 3. Firebase Auth sign in
      // 4. Firestore user creation
      UserCredential? userCredential = await AuthRepository.instance.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {

      // If we reach here, user is signed in and saved to Firestore
      print('=== GOOGLE SIGN IN SUCCESSFUL ===');

      // Get user data to show personalized message
      final userData = await AuthRepository.instance.getUserData();
      if (userData != null) {
        String userName = userData['name'] ?? 'User';
        _showSuccessSnackbar(
          'Welcome, $userName!',
          'Google Sign In successful',
        );
      } else {
        _showSuccessSnackbar(
          'Welcome!',
          'Google Sign In successful',
        );
      }

      // Clear form data
      _clearForm();

      // Navigate to main app
      Get.offAll(() => MainNavigation());

      } else {
        throw 'Google Sign In failed - no user credential returned';
      }

    } catch (e) {
      print('Google Sign In error: $e');

      // Handle specific error messages
      String errorMessage = 'Google Sign In failed. Please try again.';

      if (e.toString().contains('cancelled')) {
        errorMessage = 'Google Sign In was cancelled.';
      } else if (e.toString().contains('Phone number is required')) {
        errorMessage = 'Phone number is required to complete registration.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection.';
      }

      _showErrorSnackbar(
        'Sign In Failed',
        errorMessage,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Simplified email not verified dialog
  void _showEmailNotVerifiedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Email Not Verified',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please verify your email address before signing in.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Check your email:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('📧 ${emailController.text}'),
                  const SizedBox(height: 8),
                  const Text('Look in:'),
                  const Text('• Inbox'),
                  const Text('• Spam/Junk folder'),
                  const Text('• Promotions tab'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _resendVerificationFromLogin();
            },
            child: const Text('Resend Email'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
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


  // Resend verification email from login screen
  Future<void> _resendVerificationFromLogin() async {
    try {
      isLoading.value = true;

      // Try to sign in temporarily to resend email
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Send verification email
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      // Sign out immediately
      await FirebaseAuth.instance.signOut();

      _showSuccessSnackbar(
        'Email Sent',
        'Verification email sent successfully. Please check your inbox.',
      );

    } catch (e) {
      print('Resend verification error: $e');
      _showErrorSnackbar(
        'Send Failed',
        'Could not send verification email. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
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

  // Future<void> handleGoogleSignIn() async {
  //   try {
  //     isLoading.value = true;
  //
  //     await Future.delayed(const Duration(seconds: 1));
  //
  //     Get.offAll(() => MainNavigation());
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Google Sign In failed',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red[100],
  //       colorText: Colors.red[800],
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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