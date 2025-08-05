import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routing/navigation/navigation.dart';
import '../../../authentication/auth_repository/auth_repository.dart';
import '../../../authentication/forgot_password/forgot_password_options/forgot_password_model_bottom_sheet.dart';
import '../signup/sign_up.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
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
    if (!isFormValid) {
      Get.snackbar(
        'Error',
        'Please fill all fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    try {
      isLoading.value = true;


      await AuthRepository.instance.loginUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      Get.offAll(() => MainNavigation());

      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 4),
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

  // Navigate to forgot password
  void navigateToForgotPassword() {
    ForgotPasswordScreen.buildShowModalBottomSheet(Get.context!);
  }

  // Navigate to sign up
  void navigateToSignUp() {
    Get.to(() => const SignUp());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}