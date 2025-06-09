import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/authentication/auth_repository/auth_repository.dart';

import '../../screens/auth/login/login.dart';

class SignUpController extends GetxController {
  // Text Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;
  var acceptTerms = false.obs;
  
  // Error messages
  var fullNameError = ''.obs;
  var emailError = ''.obs;
  var phoneError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  
  // Form validation
  bool get isFormValid => 
      fullNameController.text.isNotEmpty && 
      emailController.text.isNotEmpty &&
      phoneController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty &&
      fullNameError.value.isEmpty &&
      emailError.value.isEmpty &&
      phoneError.value.isEmpty &&
      passwordError.value.isEmpty &&
      confirmPasswordError.value.isEmpty &&
      acceptTerms.value;
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  // Toggle terms acceptance
  void toggleTermsAcceptance() {
    acceptTerms.value = !acceptTerms.value;
  }
  
  // Validate full name
  void validateFullName(String value) {
    if (value.isEmpty) {
      fullNameError.value = 'Full name is required';
    } else if (value.length < 2) {
      fullNameError.value = 'Name must be at least 2 characters';
    } else {
      fullNameError.value = '';
    }
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
  
  // Validate phone
  void validatePhone(String value) {
    if (value.isEmpty) {
      phoneError.value = 'Phone number is required';
    } else if (!GetUtils.isPhoneNumber(value)) {
      phoneError.value = 'Please enter a valid phone number';
    } else {
      phoneError.value = '';
    }
  }
  
  // Validate password
  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      passwordError.value = 'Password must contain uppercase, lowercase and number';
    } else {
      passwordError.value = '';
    }
    
    // Revalidate confirm password if it's not empty
    if (confirmPasswordController.text.isNotEmpty) {
      validateConfirmPassword(confirmPasswordController.text);
    }
  }
  
  // Validate confirm password
  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
    } else if (value != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }
  
  // Handle sign up
  Future<void> handleSignUp() async {
    if (!isFormValid) {
      Get.snackbar(
        'Error',
        'Please fill all fields correctly and accept terms',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    try {
      isLoading.value = true;

      // Call registerUser with actual email and password values
      // Replace these with your actual form field values
      await registerUser(emailController.text, passwordController.text);

      // Success - Show success message
      Get.snackbar(
        'Success',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

      // Navigate to login screen or home (handled by AuthRepository)
      // Get.to(() => const Login());

    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign up failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

// Make registerUser async and await the AuthRepository call
  Future<void> registerUser(String email, String password) async {
    await AuthRepository.instance.createUserWithEmailAndPassword(email, password);
  }
  
  // Handle Google Sign Up
  Future<void> handleGoogleSignUp() async {
    try {
      isLoading.value = true;
      
      // Simulate Google Sign Up
      await Future.delayed(const Duration(seconds: 1));
      
      Get.snackbar(
        'Success',
        'Account created with Google!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google Sign Up failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Navigate to login
  void navigateToLogin() {
    Get.to(() => const Login());
  }
  
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
